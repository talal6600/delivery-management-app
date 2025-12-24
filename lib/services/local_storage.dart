import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/delivery.dart';
import '../models/inventory.dart';
import '../models/fuel.dart';
import '../models/settings.dart';
import '../config/constants.dart';

class LocalStorageService {
  static late Box<User> _userBox;
  static late Box<Delivery> _deliveryBox;
  static late Box<InventoryTransaction> _inventoryBox;
  static late Box<FaultySim> _faultySimBox;
  static late Box<FuelEntry> _fuelBox;
  static late Box<AppSettings> _settingsBox;
  
  // Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters (will be generated)
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(DeliveryAdapter());
    // Hive.registerAdapter(InventoryTransactionAdapter());
    // Hive.registerAdapter(FaultySimAdapter());
    // Hive.registerAdapter(FuelEntryAdapter());
    // Hive.registerAdapter(AppSettingsAdapter());
    
    // Open boxes
    _userBox = await Hive.openBox<User>('users');
    _deliveryBox = await Hive.openBox<Delivery>('deliveries');
    _inventoryBox = await Hive.openBox<InventoryTransaction>('inventory');
    _faultySimBox = await Hive.openBox<FaultySim>('faulty_sims');
    _fuelBox = await Hive.openBox<FuelEntry>('fuel');
    _settingsBox = await Hive.openBox<AppSettings>('settings');
    
    // Create default admin user if no users exist
    if (_userBox.isEmpty) {
      await _createDefaultAdmin();
    }
  }
  
  static Future<void> _createDefaultAdmin() async {
    final admin = User(
      id: 'admin',
      username: 'admin',
      password: 'admin123',
      displayName: 'المدير',
      role: AppConstants.roleAdmin,
      createdAt: DateTime.now(),
      isActive: true,
    );
    
    await _userBox.put(admin.id, admin);
    
    // Create default settings for admin
    final settings = AppSettings(
      userId: admin.id,
      displayName: admin.displayName,
    );
    await _settingsBox.put(admin.id, settings);
  }
  
  // User operations
  static Future<void> saveUser(User user) async {
    await _userBox.put(user.id, user);
  }
  
  static User? getUser(String id) {
    return _userBox.get(id);
  }
  
  static List<User> getAllUsers() {
    return _userBox.values.toList();
  }
  
  static User? getUserByUsername(String username) {
    return _userBox.values.firstWhere(
      (user) => user.username == username,
      orElse: () => throw Exception('User not found'),
    );
  }
  
  static Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }
  
  // Delivery operations
  static Future<void> saveDelivery(Delivery delivery) async {
    await _deliveryBox.put(delivery.id, delivery);
  }
  
  static Delivery? getDelivery(String id) {
    return _deliveryBox.get(id);
  }
  
  static List<Delivery> getDeliveriesByUser(String userId) {
    return _deliveryBox.values
        .where((delivery) => delivery.userId == userId)
        .toList();
  }
  
  static List<Delivery> getDeliveriesByDate(String userId, DateTime date) {
    return _deliveryBox.values
        .where((delivery) =>
            delivery.userId == userId &&
            delivery.dateTime.year == date.year &&
            delivery.dateTime.month == date.month &&
            delivery.dateTime.day == date.day)
        .toList();
  }
  
  static Future<void> deleteDelivery(String id) async {
    await _deliveryBox.delete(id);
  }
  
  // Inventory operations
  static Future<void> saveInventoryTransaction(InventoryTransaction transaction) async {
    await _inventoryBox.put(transaction.id, transaction);
  }
  
  static List<InventoryTransaction> getInventoryByUser(String userId) {
    return _inventoryBox.values
        .where((transaction) => transaction.userId == userId)
        .toList();
  }
  
  static Future<void> deleteInventoryTransaction(String id) async {
    await _inventoryBox.delete(id);
  }
  
  // Faulty SIM operations
  static Future<void> saveFaultySim(FaultySim faultySim) async {
    await _faultySimBox.put(faultySim.id, faultySim);
  }
  
  static List<FaultySim> getFaultySimsByUser(String userId) {
    return _faultySimBox.values
        .where((sim) => sim.userId == userId)
        .toList();
  }
  
  static Future<void> deleteFaultySim(String id) async {
    await _faultySimBox.delete(id);
  }
  
  // Fuel operations
  static Future<void> saveFuelEntry(FuelEntry entry) async {
    await _fuelBox.put(entry.id, entry);
  }
  
  static FuelEntry? getFuelEntry(String id) {
    return _fuelBox.get(id);
  }
  
  static List<FuelEntry> getFuelEntriesByUser(String userId) {
    return _fuelBox.values
        .where((entry) => entry.userId == userId)
        .toList();
  }
  
  static Future<void> deleteFuelEntry(String id) async {
    await _fuelBox.delete(id);
  }
  
  // Settings operations
  static Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put(settings.userId, settings);
  }
  
  static AppSettings? getSettings(String userId) {
    return _settingsBox.get(userId);
  }
  
  // Clear all data (for testing or reset)
  static Future<void> clearAll() async {
    await _userBox.clear();
    await _deliveryBox.clear();
    await _inventoryBox.clear();
    await _faultySimBox.clear();
    await _fuelBox.clear();
    await _settingsBox.clear();
    await _createDefaultAdmin();
  }
}
