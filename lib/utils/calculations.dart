import '../config/constants.dart';

class Calculations {
  // Calculate delivery commission based on type and time range
  static double calculateDeliveryCommission({
    required String deliveryType,
    required String timeRange,
    Map<String, Map<String, double>>? customRates,
  }) {
    // For incomplete deliveries, always return fixed commission
    if (deliveryType == AppConstants.deliveryIncomplete) {
      return AppConstants.incompleteCommission;
    }
    
    // For device sales, commission should be provided separately
    if (deliveryType == AppConstants.deliveryDevice) {
      return 0.0; // Will be set manually
    }
    
    // Use custom rates if provided, otherwise use default rates
    final rates = customRates ?? AppConstants.defaultCommissionRates;
    
    return rates[deliveryType]?[timeRange] ?? 0.0;
  }
  
  // Calculate fuel cost
  static double calculateFuelCost({
    required String fuelType,
    required double liters,
  }) {
    final pricePerLiter = AppConstants.fuelPrices[fuelType] ?? 0.0;
    return liters * pricePerLiter;
  }
  
  // Calculate fuel consumption rate (km/liter)
  static double calculateConsumptionRate({
    required double distance,
    required double liters,
  }) {
    if (liters <= 0) return 0.0;
    return distance / liters;
  }
  
  // Calculate weekly goal progress percentage
  static double calculateWeeklyProgress({
    required double totalEarned,
    required double weeklyGoal,
  }) {
    if (weeklyGoal <= 0) return 0.0;
    return (totalEarned / weeklyGoal * 100).clamp(0.0, 100.0);
  }
  
  // Calculate average consumption for a period
  static double calculateAverageConsumption(List<double> consumptionRates) {
    if (consumptionRates.isEmpty) return 0.0;
    return consumptionRates.reduce((a, b) => a + b) / consumptionRates.length;
  }
  
  // Calculate total deliveries by type
  static Map<String, int> calculateDeliveriesByType(List<Map<String, dynamic>> deliveries) {
    final result = <String, int>{
      AppConstants.deliveryJawy: 0,
      AppConstants.deliverySawa: 0,
      AppConstants.deliveryMultiple: 0,
      AppConstants.deliveryIncomplete: 0,
      AppConstants.deliveryDevice: 0,
    };
    
    for (var delivery in deliveries) {
      final type = delivery['type'] as String?;
      if (type != null && result.containsKey(type)) {
        result[type] = (result[type] ?? 0) + 1;
      }
    }
    
    return result;
  }
  
  // Calculate total commissions
  static double calculateTotalCommissions(List<Map<String, dynamic>> deliveries) {
    return deliveries.fold(0.0, (sum, delivery) {
      final commission = delivery['commission'] as double? ?? 0.0;
      return sum + commission;
    });
  }
  
  // Calculate inventory remaining after deliveries
  static Map<String, int> calculateRemainingInventory({
    required Map<String, int> totalInventory,
    required Map<String, int> usedInventory,
  }) {
    final remaining = <String, int>{};
    
    for (var type in totalInventory.keys) {
      final total = totalInventory[type] ?? 0;
      final used = usedInventory[type] ?? 0;
      remaining[type] = (total - used).clamp(0, total);
    }
    
    return remaining;
  }
}
