import 'package:flutter/foundation.dart';
import '../models/settings.dart';
import '../services/local_storage.dart';
import '../config/constants.dart';

class SettingsProvider with ChangeNotifier {
  final String userId;
  AppSettings? _settings;
  
  SettingsProvider({required this.userId}) {
    loadSettings();
  }
  
  AppSettings? get settings => _settings;
  double get weeklyGoal => _settings?.weeklyGoal ?? AppConstants.defaultWeeklyGoal;
  String get preferredFuelType => _settings?.preferredFuelType ?? AppConstants.defaultFuelType;
  Map<String, Map<String, double>> get commissionRates =>
      _settings?.commissionRates ?? AppConstants.defaultCommissionRates;
  String get displayName => _settings?.displayName ?? '';
  
  // Load settings
  void loadSettings() {
    _settings = LocalStorageService.getSettings(userId);
    
    // Create default settings if not exist
    if (_settings == null) {
      _settings = AppSettings(
        userId: userId,
        displayName: 'مستخدم',
      );
      saveSettings();
    }
    
    notifyListeners();
  }
  
  // Save settings
  Future<void> saveSettings() async {
    if (_settings != null) {
      await LocalStorageService.saveSettings(_settings!);
      notifyListeners();
    }
  }
  
  // Update weekly goal
  Future<void> updateWeeklyGoal(double goal) async {
    if (_settings != null) {
      _settings = _settings!.copyWith(weeklyGoal: goal);
      await saveSettings();
    }
  }
  
  // Update preferred fuel type
  Future<void> updatePreferredFuelType(String fuelType) async {
    if (_settings != null) {
      _settings = _settings!.copyWith(preferredFuelType: fuelType);
      await saveSettings();
    }
  }
  
  // Update commission rates
  Future<void> updateCommissionRates(Map<String, Map<String, double>> rates) async {
    if (_settings != null) {
      _settings = _settings!.copyWith(commissionRates: rates);
      await saveSettings();
    }
  }
  
  // Update commission rate for specific type and time range
  Future<void> updateCommissionRate({
    required String deliveryType,
    required String timeRange,
    required double rate,
  }) async {
    if (_settings != null) {
      final newRates = Map<String, Map<String, double>>.from(_settings!.commissionRates);
      
      if (!newRates.containsKey(deliveryType)) {
        newRates[deliveryType] = {};
      }
      
      newRates[deliveryType]![timeRange] = rate;
      
      _settings = _settings!.copyWith(commissionRates: newRates);
      await saveSettings();
    }
  }
  
  // Update display name
  Future<void> updateDisplayName(String name) async {
    if (_settings != null) {
      _settings = _settings!.copyWith(displayName: name);
      await saveSettings();
    }
  }
  
  // Reset to default commission rates
  Future<void> resetCommissionRates() async {
    if (_settings != null) {
      _settings = _settings!.copyWith(
        commissionRates: AppConstants.defaultCommissionRates,
      );
      await saveSettings();
    }
  }
  
  // Reset all settings to default
  Future<void> resetToDefaults() async {
    _settings = AppSettings(
      userId: userId,
      displayName: displayName,
    );
    await saveSettings();
  }
  
  // Get commission rate for specific type and time range
  double getCommissionRate(String deliveryType, String timeRange) {
    return _settings?.commissionRates[deliveryType]?[timeRange] ?? 0.0;
  }
}
