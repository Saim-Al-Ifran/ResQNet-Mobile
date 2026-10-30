import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/database/app_database.dart';

export 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Non-blocking background log for SQLite debug check
  AppDatabase.debugSavedDisasterEvents();

  runApp(const ResQNetApp());
}
