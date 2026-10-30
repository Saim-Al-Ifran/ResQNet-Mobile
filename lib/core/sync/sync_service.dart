import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../../features/events/data/repositories/event_repository.dart';

class SyncService extends GetxService {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isSyncing = false;

  @override
  void onInit() {
    super.onInit();

    // Listen for internet connection changes.
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final hasConnection =
            results.any((result) => result != ConnectivityResult.none);

        if (hasConnection) {
          syncReports();
        }
      },
    );

    // Check internet connection when app starts.
    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();

      final hasConnection =
          results.any((result) => result != ConnectivityResult.none);

      if (hasConnection) {
        await syncReports();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Initial connectivity check failed: $e');
    }
  }

  Future<void> syncReports() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      // ignore: avoid_print
      print('Internet available. Starting auto sync...');

      final result = await EventRepository().syncPendingReports();

      // ignore: avoid_print
      print('Auto sync result: $result');
    } catch (e) {
      // ignore: avoid_print
      print('Auto sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
