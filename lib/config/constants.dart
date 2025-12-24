class AppConstants {
  // Delivery Types
  static const String deliveryJawy = 'jawy';
  static const String deliverySawa = 'sawa';
  static const String deliveryMultiple = 'multiple';
  static const String deliveryIncomplete = 'incomplete';
  static const String deliveryDevice = 'device';
  
  // Delivery Names (Arabic)
  static const String deliveryJawyName = 'جوي';
  static const String deliverySawaName = 'سوا';
  static const String deliveryMultipleName = 'متعدد';
  static const String deliveryIncompleteName = 'لم يكتمل';
  static const String deliveryDeviceName = 'جهاز';
  
  // Time Ranges
  static const String timeRangeLessThan2 = 'less_than_2';
  static const String timeRange2To3 = '2_to_3';
  static const String timeRangeMoreThan3 = 'more_than_3';
  
  // Time Range Names (Arabic)
  static const String timeRangeLessThan2Name = 'أقل من ساعتين';
  static const String timeRange2To3Name = '2-3 ساعات';
  static const String timeRangeMoreThan3Name = 'أكثر من 3 ساعات';
  
  // Default Commission Rates (SAR)
  static const Map<String, Map<String, double>> defaultCommissionRates = {
    deliveryJawy: {
      timeRangeLessThan2: 30.0,
      timeRange2To3: 25.0,
      timeRangeMoreThan3: 20.0,
    },
    deliverySawa: {
      timeRangeLessThan2: 28.0,
      timeRange2To3: 24.0,
      timeRangeMoreThan3: 20.0,
    },
    deliveryMultiple: {
      timeRangeLessThan2: 28.0,
      timeRange2To3: 24.0,
      timeRangeMoreThan3: 20.0,
    },
  };
  
  static const double incompleteCommission = 10.0;
  
  // Fuel Types
  static const String fuel91 = 'fuel_91';
  static const String fuel95 = 'fuel_95';
  
  // Fuel Names (Arabic)
  static const String fuel91Name = 'أخضر 91';
  static const String fuel95Name = 'أحمر 95';
  
  // Fuel Prices (SAR/Liter)
  static const Map<String, double> fuelPrices = {
    fuel91: 2.18,
    fuel95: 2.33,
  };
  
  // Default Settings
  static const double defaultWeeklyGoal = 1000.0;
  static const String defaultFuelType = fuel91;
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleDelegate = 'delegate';
  
  // Subscription Periods
  static const String subscriptionWeek = 'week';
  static const String subscriptionMonth = 'month';
  
  // Storage Keys
  static const String keyCurrentUser = 'current_user';
  static const String keyUsers = 'users';
  static const String keyDeliveries = 'deliveries';
  static const String keyInventory = 'inventory';
  static const String keyFuel = 'fuel';
  static const String keySettings = 'settings';
  static const String keyFaultySims = 'faulty_sims';
  
  // Multiple SIM Card Options
  static const List<int> multipleSimOptions = [1, 2, 3];
}
