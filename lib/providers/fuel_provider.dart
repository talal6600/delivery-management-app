import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/fuel.dart';
import '../services/local_storage.dart';
import '../utils/date_utils.dart';
import '../utils/calculations.dart';
import '../config/constants.dart';

class FuelProvider with ChangeNotifier {
  final String userId;
  List<FuelEntry> _entries = [];
  
  FuelProvider({required this.userId}) {
    loadFuelEntries();
  }
  
  List<FuelEntry> get entries => _entries;
  
  // Load fuel entries
  void loadFuelEntries() {
    _entries = LocalStorageService.getFuelEntriesByUser(userId);
    _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }
  
  // Get entries for a specific date
  List<FuelEntry> getEntriesForDate(DateTime date) {
    return _entries.where((entry) {
      return DateTimeUtils.isSameDay(entry.dateTime, date);
    }).toList();
  }
  
  // Get entries for a specific week
  List<FuelEntry> getEntriesForWeek(DateTime date) {
    final weekStart = DateTimeUtils.getWeekStart(date);
    final weekEnd = DateTimeUtils.getWeekEnd(date);
    
    return _entries.where((entry) {
      return entry.dateTime.isAfter(weekStart) &&
          entry.dateTime.isBefore(weekEnd);
    }).toList();
  }
  
  // Get entries for a specific month
  List<FuelEntry> getEntriesForMonth(DateTime date) {
    return _entries.where((entry) {
      return DateTimeUtils.isSameMonth(entry.dateTime, date);
    }).toList();
  }
  
  // Calculate weekly summary
  Map<String, dynamic> getWeeklySummary(DateTime date) {
    final weekEntries = getEntriesForWeek(date);
    
    double totalLiters = 0;
    double totalCost = 0;
    final consumptionRates = <double>[];
    
    for (var entry in weekEntries) {
      totalLiters += entry.liters;
      totalCost += entry.cost;
      if (entry.consumptionRate != null) {
        consumptionRates.add(entry.consumptionRate!);
      }
    }
    
    return {
      'totalLiters': totalLiters,
      'totalCost': totalCost,
      'averageConsumption': consumptionRates.isNotEmpty
          ? Calculations.calculateAverageConsumption(consumptionRates)
          : 0.0,
      'entryCount': weekEntries.length,
    };
  }
  
  // Calculate monthly summary
  Map<String, dynamic> getMonthlySummary(DateTime date) {
    final monthEntries = getEntriesForMonth(date);
    
    double totalLiters = 0;
    double totalCost = 0;
    final consumptionRates = <double>[];
    
    for (var entry in monthEntries) {
      totalLiters += entry.liters;
      totalCost += entry.cost;
      if (entry.consumptionRate != null) {
        consumptionRates.add(entry.consumptionRate!);
      }
    }
    
    return {
      'totalLiters': totalLiters,
      'totalCost': totalCost,
      'averageConsumption': consumptionRates.isNotEmpty
          ? Calculations.calculateAverageConsumption(consumptionRates)
          : 0.0,
      'entryCount': monthEntries.length,
    };
  }
  
  // Calculate daily consumption rate
  double? getDailyConsumptionRate(DateTime date) {
    final dailyEntries = getEntriesForDate(date);
    final rates = dailyEntries
        .where((entry) => entry.consumptionRate != null)
        .map((entry) => entry.consumptionRate!)
        .toList();
    
    if (rates.isEmpty) return null;
    return Calculations.calculateAverageConsumption(rates);
  }
  
  // Add new fuel entry
  Future<bool> addFuelEntry({
    required String fuelType,
    required double liters,
    double? distance,
    DateTime? date,
    String? notes,
  }) async {
    try {
      final cost = Calculations.calculateFuelCost(
        fuelType: fuelType,
        liters: liters,
      );
      
      final entry = FuelEntry(
        id: const Uuid().v4(),
        userId: userId,
        fuelType: fuelType,
        liters: liters,
        cost: cost,
        distance: distance,
        dateTime: date ?? DateTime.now(),
        notes: notes,
      );
      
      await LocalStorageService.saveFuelEntry(entry);
      _entries.add(entry);
      _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Update fuel entry
  Future<bool> updateFuelEntry(FuelEntry entry) async {
    try {
      await LocalStorageService.saveFuelEntry(entry);
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
        _entries.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Delete fuel entry
  Future<bool> deleteFuelEntry(String id) async {
    try {
      await LocalStorageService.deleteFuelEntry(id);
      _entries.removeWhere((e) => e.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Get total cost for a period
  double getTotalCost(DateTime startDate, DateTime endDate) {
    return _entries
        .where((entry) =>
            entry.dateTime.isAfter(startDate) &&
            entry.dateTime.isBefore(endDate))
        .fold(0.0, (sum, entry) => sum + entry.cost);
  }
  
  // Get total liters for a period
  double getTotalLiters(DateTime startDate, DateTime endDate) {
    return _entries
        .where((entry) =>
            entry.dateTime.isAfter(startDate) &&
            entry.dateTime.isBefore(endDate))
        .fold(0.0, (sum, entry) => sum + entry.liters);
  }
}
