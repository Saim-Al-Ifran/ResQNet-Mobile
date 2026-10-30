import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../core/database/app_database.dart';
import '../../data/models/disaster_event_model.dart';
import '../../data/repositories/event_repository.dart';

/// GetX controller managing state, location, validation, and local persistence for disaster events.
class ReportEventController extends GetxController {
  final EventRepository _eventRepository = EventRepository();

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
  final savedReportCount = 0.obs;
  final isSyncing = false.obs;
  final syncMessage = ''.obs;

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

    final fallbackAddress =
        'Location (${latitude.toStringAsFixed(4)}, '
        '${longitude.toStringAsFixed(4)})';

    try {
      if (kIsWeb) {
        currentAddress.value = fallbackAddress;
        return;
      }

      final placemarks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(
        const Duration(seconds: 8),
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
        parts.isEmpty ? fallbackAddress : parts.join(', ');
      } else {
        currentAddress.value = fallbackAddress;
      }
    } catch (e) {
      debugPrint('Address lookup failed: $e');
      currentAddress.value = fallbackAddress;
    } finally {
      isGettingAddress.value = false;
    }
  }

  Future<void> detectCurrentLocation() async {
    if (isGettingLocation.value) return;

    isGettingLocation.value = true;
    locationError.value = null;

    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        final enabledAfterSettings =
        await Geolocator.isLocationServiceEnabled();

        if (!enabledAfterSettings) {
          locationError.value =
          'Please turn on your device location.';
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

      // GPS coordinates: maximum 15 seconds.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // Save coordinates immediately.
      currentPosition.value = position;

      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();

      // GPS loading ends here.
      isGettingLocation.value = false;

      // Address lookup runs separately.
      await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      debugPrint('Location detection failed: $e');

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

  @override
  void onInit() {
    super.onInit();
    refreshSavedReportCount();
  }

  /// Saves the disaster report into the local SQLite database
  Future<String> saveReportLocally() async {
    final report = buildReportModel();

    final localId = await _eventRepository.saveReportLocally(report);

    await refreshSavedReportCount();

    return localId;
  }

  Future<int> getSavedReportCount() async {
    final reports = await _eventRepository.getSavedReports();
    return reports.length;
  }

  Future<void> refreshSavedReportCount() async {
    savedReportCount.value = await getSavedReportCount();
  }

  Future<void> retryPendingSync() async {
    if (isSyncing.value) return;

    isSyncing.value = true;
    syncMessage.value = 'Syncing pending reports...';

    try {
      final result = await _eventRepository.syncPendingReports();

      await refreshSavedReportCount();

      final synced = result['synced'] ?? 0;
      final failed = result['failed'] ?? 0;

      if (failed == 0) {
        syncMessage.value = '$synced report(s) synced successfully.';
      } else {
        syncMessage.value =
            '$synced synced, $failed failed. Try again later.';
      }
    } catch (e) {
      syncMessage.value = 'Sync failed. Please try again.';
      // ignore: avoid_print
      print('Manual sync error: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  /// Runs debug test to fetch and print saved reports
  Future<void> testSavedReports() async {
    // ignore: avoid_print
    print('----------------------------------------');
    // ignore: avoid_print
    print('Executing testSavedReports()...');
    await AppDatabase.debugSavedDisasterEvents();
    // ignore: avoid_print
    print('----------------------------------------');
  }

  @override
  void onClose() {
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}


