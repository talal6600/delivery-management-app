import 'package:flutter/material.dart';
import '../screens/login/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/inventory/inventory_screen.dart';
import '../screens/fuel/fuel_screen.dart';
import '../screens/reports/reports_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String inventory = '/inventory';
  static const String fuel = '/fuel';
  static const String reports = '/reports';
  static const String settings = '/settings';
  
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      inventory: (context) => const InventoryScreen(),
      fuel: (context) => const FuelScreen(),
      reports: (context) => const ReportsScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
  
  static String get initialRoute => login;
}
