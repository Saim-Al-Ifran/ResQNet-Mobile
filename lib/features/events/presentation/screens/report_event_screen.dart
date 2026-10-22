import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_theme.dart';
import '../controllers/report_event_controller.dart';

class ReportEventScreen extends StatefulWidget {
  const ReportEventScreen({super.key});

  @override
  State<ReportEventScreen> createState() => _ReportEventScreenState();
}

class _ReportEventScreenState extends State<ReportEventScreen> {
  @override
  Widget build(BuildContext context) {
    final ReportEventController controller =
        Get.put(ReportEventController());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: const Text('Report a Disaster'),
        backgroundColor: AppTheme.lightBackground,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Help your community stay safe.',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Provide accurate information about the incident.',
            ),
            const SizedBox(height: 24),

            const Text(
              'Disaster type',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Obx(
              () => DropdownButtonFormField<String>(
                initialValue: controller.selectedEventType.value,
                decoration: _decoration('Select disaster type'),
                items: controller.eventTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a disaster type.';
                  }
                  return null;
                },
                onChanged: (value) {
                  controller.selectedEventType.value = value;
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 4,
              maxLength: 500,
              decoration: _decoration(
                'Describe what happened',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required.';
                }
                if (value.trim().length > 500) {
                  return 'Maximum 500 characters allowed.';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            const Text(
              'Incident location',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            Obx(() {
              final position = controller.currentPosition.value;
              final isLoading = controller.isGettingLocation.value;
              final error = controller.locationError.value;

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: AppTheme.primaryRed),
                        SizedBox(width: 8),
                        Text(
                          'Disaster Location',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (position != null) ...[
                      Text(
                        controller.isGettingAddress.value
                            ? 'Finding your address...'
                            : controller.currentAddress.value ??
                                'Address unavailable',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'GPS: ${position.latitude.toStringAsFixed(5)}, '
                        '${position.longitude.toStringAsFixed(5)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ] else
                      Text(error ?? 'Detect your current location to continue.'),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : controller.detectCurrentLocation,
                        icon: isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(
                          isLoading
                              ? 'Detecting location...'
                              : position == null
                                  ? 'Detect My Location'
                                  : 'Refresh Location',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 28),

            Obx(
              () => SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () async {
                          final formIsValid =
                              formKey.currentState!.validate();
                          final reportError = controller.validateReport();

                          if (!formIsValid) return;

                          if (reportError != null) {
                            Get.snackbar(
                              'Check your report',
                              reportError,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          try {
                            controller.isSubmitting.value = true;

                            final localId =
                                await controller.saveReportLocally();

                            Get.snackbar(
                              'Saved Offline',
                              'Report saved on this device. ID: $localId',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Save Failed',
                              'Could not save the report locally. Please try again.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } finally {
                            controller.isSubmitting.value = false;
                          }
                        },
                  icon: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded),
                  label: Text(
                    controller.isSubmitting.value
                        ? 'Saving Report...'
                        : 'Submit Report',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E7ED),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.primaryRed,
        ),
      ),
    );
  }
}
