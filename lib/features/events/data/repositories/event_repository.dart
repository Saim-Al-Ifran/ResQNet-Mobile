import 'package:get/get.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/api_client.dart';
import '../models/disaster_event_model.dart';

class EventRepository {
  Future<String> saveReportLocally(
      DisasterEventModel report,
      ) async {
    return await AppDatabase.saveDisasterEvent(
      eventType: report.eventType,
      latitude: report.latitude,
      longitude: report.longitude,
      description: report.description,
    );
  }

  Future<List<Map<String, Object?>>> getSavedReports() async {
    return await AppDatabase.getSavedDisasterEvents();
  }


  Future<List<Map<String, Object?>>> getPendingReports() async {
    return await AppDatabase.getPendingDisasterEvents();
  }

  Future<List<Map<String, dynamic>>> getPendingReportsAsJson() async {
    final reports = await getPendingReports();

    return reports.map((report) {
      return <String, dynamic>{
        'local_id': report['local_id'],
        'event_type': report['event_type'],
        'latitude': report['latitude'],
        'longitude': report['longitude'],
        'description': report['description'],
        'local_created_at': report['local_created_at'],
      };
    }).toList();
  }

  Future<bool> markReportAsSynced(String localId) async {
    final updatedRows =
        await AppDatabase.markDisasterEventAsSynced(localId);

    return updatedRows > 0;
  }

  Future<Map<String, int>> syncPendingReports() async {
    final apiClient = Get.find<ApiClient>();

    final reports = await getPendingReportsAsJson();

    int syncedCount = 0;
    int failedCount = 0;

    // ignore: avoid_print
    print('Total pending reports: ${reports.length}');

    for (final report in reports) {
      final localId = report['local_id'] as String;

      try {
        // ignore: avoid_print
        print('Syncing report: $localId');

        final response = await apiClient.postRequest(
          ApiClient.reportEndpoint,
          report,
        );

        final statusCode = response.statusCode;

        if (statusCode != null &&
            statusCode >= 200 &&
            statusCode < 300 &&
            !(response.body is Map &&
                response.body['success'] == false)) {
          final updated = await markReportAsSynced(localId);

          if (updated) {
            syncedCount++;
            // ignore: avoid_print
            print('Report synced successfully: $localId');
          } else {
            failedCount++;
            // ignore: avoid_print
            print('Could not update local sync status: $localId');
          }
        } else {
          failedCount++;
          // ignore: avoid_print
          print('Sync failed. Status: $statusCode');
          // ignore: avoid_print
          print('Server response: ${response.body}');
          break;
        }
      } catch (e) {
        failedCount++;
        // ignore: avoid_print
        print('Sync error for $localId: $e');
        break;
      }
    }

    // ignore: avoid_print
    print('Sync completed.');
    // ignore: avoid_print
    print('Successfully synced: $syncedCount');
    // ignore: avoid_print
    print('Failed: $failedCount');

    return {
      'total': reports.length,
      'synced': syncedCount,
      'failed': failedCount,
    };
  }
}
