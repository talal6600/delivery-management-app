import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/delivery.dart';
import '../services/local_storage.dart';
import '../utils/date_utils.dart';
import '../utils/calculations.dart';
import '../config/constants.dart';

class DeliveryProvider with ChangeNotifier {
  final String userId;
  List<Delivery> _deliveries = [];
  DateTime _selectedDate = DateTime.now();
  Map<String, Map<String, double>>? _customRates;
  
  DeliveryProvider({required this.userId}) {
    loadDeliveries();
  }
  
  List<Delivery> get deliveries => _deliveries;
  DateTime get selectedDate => _selectedDate;
  
  // Load deliveries for the current user
  void loadDeliveries() {
    _deliveries = LocalStorageService.getDeliveriesByUser(userId);
    notifyListeners();
  }
  
  // Get deliveries for a specific date
  List<Delivery> getDeliveriesForDate(DateTime date) {
    return _deliveries.where((delivery) {
      return DateTimeUtils.isSameDay(delivery.dateTime, date);
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
  
  // Get deliveries for current week
  List<Delivery> getDeliveriesForWeek(DateTime date) {
    final weekStart = DateTimeUtils.getWeekStart(date);
    final weekEnd = DateTimeUtils.getWeekEnd(date);
    
    return _deliveries.where((delivery) {
      return delivery.dateTime.isAfter(weekStart) &&
          delivery.dateTime.isBefore(weekEnd);
    }).toList();
  }
  
  // Get deliveries for current month
  List<Delivery> getDeliveriesForMonth(DateTime date) {
    return _deliveries.where((delivery) {
      return DateTimeUtils.isSameMonth(delivery.dateTime, date);
    }).toList();
  }
  
  // Calculate daily summary
  Map<String, int> getDailySummary(DateTime date) {
    final dailyDeliveries = getDeliveriesForDate(date);
    return Calculations.calculateDeliveriesByType(
      dailyDeliveries.map((d) => d.toJson()).toList(),
    );
  }
  
  // Calculate weekly total commission
  double getWeeklyCommission(DateTime date) {
    final weeklyDeliveries = getDeliveriesForWeek(date);
    return Calculations.calculateTotalCommissions(
      weeklyDeliveries.map((d) => d.toJson()).toList(),
    );
  }
  
  // Calculate daily total commission
  double getDailyCommission(DateTime date) {
    final dailyDeliveries = getDeliveriesForDate(date);
    return Calculations.calculateTotalCommissions(
      dailyDeliveries.map((d) => d.toJson()).toList(),
    );
  }
  
  // Add new delivery
  Future<bool> addDelivery({
    required String type,
    String? timeRange,
    int? simCount,
    double? customCommission,
    String? notes,
  }) async {
    try {
      double commission;
      
      if (type == AppConstants.deliveryDevice) {
        commission = customCommission ?? 0.0;
      } else if (type == AppConstants.deliveryIncomplete) {
        commission = AppConstants.incompleteCommission;
      } else {
        commission = Calculations.calculateDeliveryCommission(
          deliveryType: type,
          timeRange: timeRange ?? AppConstants.timeRangeLessThan2,
          customRates: _customRates,
        );
      }
      
      final delivery = Delivery(
        id: const Uuid().v4(),
        userId: userId,
        type: type,
        timeRange: timeRange,
        simCount: simCount,
        commission: commission,
        dateTime: _selectedDate,
        notes: notes,
      );
      
      await LocalStorageService.saveDelivery(delivery);
      _deliveries.add(delivery);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Delete delivery
  Future<bool> deleteDelivery(String id) async {
    try {
      await LocalStorageService.deleteDelivery(id);
      _deliveries.removeWhere((d) => d.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  // Go to previous day
  void previousDay() {
    _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    notifyListeners();
  }
  
  // Go to next day
  void nextDay() {
    _selectedDate = _selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }
  
  // Set custom commission rates
  void setCustomRates(Map<String, Map<String, double>> rates) {
    _customRates = rates;
    notifyListeners();
  }
  
  // Get count of deliveries by type for selected date
  int getDeliveryCount(String type, DateTime date) {
    return getDeliveriesForDate(date)
        .where((d) => d.type == type)
        .length;
  }
}
