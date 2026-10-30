
import 'package:get/get.dart';

import '../../core/network/api_client.dart';
import '../../core/sync/sync_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(
      ApiClient(),
      permanent: true,
    );
    Get.put<SyncService>(
      SyncService(),
      permanent: true,
    );
  }
}
