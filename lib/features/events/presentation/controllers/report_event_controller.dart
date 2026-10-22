import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../core/database/app_database.dart';
import '../../data/models/disaster_event_model.dart';

/// GetX controller managing state, location, validation, and local persistence for disaster events.
class ReportEventController extends GetxController {
  final selectedEventType = RxnString();
  final descriptionController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  final isSubmitting = false.obs;
  final isGettingLocation = false.obs;
  final locationError = RxnString();
  final currentPosition = Rxn<Position>();

  final currentAddress = RxnString();
  final isGettingAddress = false.obs;

  final eventTypes = const [
    'FLOOD',
    'FIRE',
    'EARTHQUAKE',
    'LANDSLIDE',
    'ACCIDENT',
    'STORM',
    'HEATWAVE',
    'OTHER',
  ];

  /// Validates inputs before submitting a disaster report
  String? validateReport() {
    if (selectedEventType.value == null) {
      return 'Please select a disaster type.';
    }

    final description = descriptionController.text.trim();

    if (description.isEmpty) {
      return 'Please enter a description.';
    }

    if (description.length > 500) {
      return 'Description cannot exceed 500 characters.';
    }

    if (currentPosition.value == null) {
      return 'Please detect your location first.';
    }

    return null;
  }

  Future<void> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    isGettingAddress.value = true;
    currentAddress.value = null;

    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.subAdministrativeArea,
          place.administrativeArea,
          place.country,
        ]
            .whereType<String>()
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toSet()
            .toList();

        currentAddress.value =
            parts.isEmpty ? 'Address unavailable' : parts.join(', ');
      } else {
        currentAddress.value = 'Address unavailable';
      }
    } catch (_) {
      currentAddress.value = 'Could not retrieve address';
    } finally {
      isGettingAddress.value = false;
    }
  }

  Future<void> detectCurrentLocation() async {
    isGettingLocation.value = true;
    locationError.value = null;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        final enabledAfterSettings =
            await Geolocator.isLocationServiceEnabled();

        if (!enabledAfterSettings) {
          locationError.value = 'Please turn on your device location.';
          return;
        }
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        locationError.value = 'Location permission was denied.';
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value =
            'Enable location permission from app settings.';
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      currentPosition.value = position;
      await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (_) {
      locationError.value =
          'Could not detect location. Please try again.';
    } finally {
      isGettingLocation.value = false;
    }
  }

  DisasterEventModel buildReportModel() {
    final position = currentPosition.value;

    if (position == null) {
      throw StateError('Location has not been detected.');
    }

    return DisasterEventModel(
      eventType: selectedEventType.value!,
      latitude: position.latitude,
      longitude: position.longitude,
      description: descriptionController.text.trim(),
    );
  }

  /// Saves the disaster report into the local SQLite database
  Future<String> saveReportLocally() async {
    final report = buildReportModel();

    final localId = await AppDatabase.saveDisasterEvent(
      eventType: report.eventType,
      latitude: report.latitude,
      longitude: report.longitude,
      description: report.description,
    );

    return localId;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}
