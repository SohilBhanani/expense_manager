import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'features/database/database.dart';
import 'features/prefs/prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  MobileAds.instance.initialize();
  await setupPreferances();
  await setupDatabase();

  runApp(const MyApp());
}

setupPreferances() async {
  await Prefs.init();
}

setupDatabase() async {
  await AccountDatabase.init();
}
