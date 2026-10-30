import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/network/api_client.dart';
import '../core/sync/sync_service.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class ResQNetApp extends StatelessWidget {
  const ResQNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ResQNet',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,


        initialBinding: BindingsBuilder(() {
          Get.put(ThemeController());
          Get.put<ApiClient>(
            ApiClient(),
            permanent: true,
          );
          Get.put<SyncService>(
            SyncService(),
            permanent: true,
          );
        }),
    );
  }
}
