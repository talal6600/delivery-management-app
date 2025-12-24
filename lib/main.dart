import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/local_storage.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize local storage
  await LocalStorageService.init();
  
  // Initialize Firebase (optional, can be configured later)
  // await Firebase.initializeApp();
  
  runApp(const MyApp());
}
