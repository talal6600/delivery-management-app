import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/inventory.dart';
import '../services/local_storage.dart';
import '../config/constants.dart';

class InventoryProvider with ChangeNotifier {
  final String userId;
  List<InventoryTransaction> _transactions = [];
  List<FaultySim> _faultySims = [];
  
  InventoryProvider({required this.userId}) {
    loadInventory();
  }
  
  List<InventoryTransaction> get transactions => _transactions;
  List<FaultySim> get faultySims => _faultySims;
  
  // Load inventory data
  void loadInventory() {
    _transactions = LocalStorageService.getInventoryByUser(userId);
    _faultySims = LocalStorageService.getFaultySimsByUser(userId);
    notifyListeners();
  }
  
  // Calculate total inventory by type
  Map<String, int> getTotalInventory() {
    final inventory = <String, int>{
      AppConstants.deliveryJawy: 0,
      AppConstants.deliverySawa: 0,
      AppConstants.deliveryMultiple: 0,
    };
    
    for (var transaction in _transactions) {
      if (transaction.transactionType == 'received') {
        inventory[transaction.type] = (inventory[transaction.type] ?? 0) + transaction.quantity;
      } else if (transaction.transactionType == 'used' || transaction.transactionType == 'faulty') {
        inventory[transaction.type] = (inventory[transaction.type] ?? 0) - transaction.quantity;
      } else if (transaction.transactionType == 'returned') {
        inventory[transaction.type] = (inventory[transaction.type] ?? 0) + transaction.quantity;
      }
    }
    
    // Ensure no negative values
    inventory.updateAll((key, value) => value < 0 ? 0 : value);
    
    return inventory;
  }
  
  // Get total inventory count
  int getTotalInventoryCount() {
    final inventory = getTotalInventory();
    return inventory.values.fold(0, (sum, count) => sum + count);
  }
  
  // Get inventory count for a specific type
  int getInventoryCount(String type) {
    return getTotalInventory()[type] ?? 0;
  }
  
  // Add received inventory
  Future<bool> receiveInventory({
    required String type,
    required int quantity,
    DateTime? date,
    String? notes,
  }) async {
    try {
      final transaction = InventoryTransaction(
        id: const Uuid().v4(),
        userId: userId,
        type: type,
        quantity: quantity,
        transactionType: 'received',
        dateTime: date ?? DateTime.now(),
        notes: notes,
      );
      
      await LocalStorageService.saveInventoryTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Record used inventory (when delivery is made)
  Future<bool> useInventory({
    required String type,
    required int quantity,
    String? deliveryId,
  }) async {
    try {
      // Check if enough inventory is available
      if (getInventoryCount(type) < quantity) {
        return false;
      }
      
      final transaction = InventoryTransaction(
        id: const Uuid().v4(),
        userId: userId,
        type: type,
        quantity: quantity,
        transactionType: 'used',
        dateTime: DateTime.now(),
        linkedDeliveryId: deliveryId,
      );
      
      await LocalStorageService.saveInventoryTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Add faulty SIM
  Future<bool> addFaultySim({
    required String type,
    required int quantity,
    String? notes,
  }) async {
    try {
      // Check if enough inventory is available
      if (getInventoryCount(type) < quantity) {
        return false;
      }
      
      // Create faulty sim record
      final faultySim = FaultySim(
        id: const Uuid().v4(),
        userId: userId,
        type: type,
        quantity: quantity,
        dateTime: DateTime.now(),
        status: 'pending',
        notes: notes,
      );
      
      await LocalStorageService.saveFaultySim(faultySim);
      _faultySims.add(faultySim);
      
      // Deduct from inventory
      final transaction = InventoryTransaction(
        id: const Uuid().v4(),
        userId: userId,
        type: type,
        quantity: quantity,
        transactionType: 'faulty',
        dateTime: DateTime.now(),
        notes: 'شرائح معطلة',
      );
      
      await LocalStorageService.saveInventoryTransaction(transaction);
      _transactions.add(transaction);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Return faulty SIM to company
  Future<bool> returnFaultyToCompany(String faultySimId) async {
    try {
      final index = _faultySims.indexWhere((sim) => sim.id == faultySimId);
      if (index == -1) return false;
      
      final faultySim = _faultySims[index];
      final updatedSim = FaultySim(
        id: faultySim.id,
        userId: faultySim.userId,
        type: faultySim.type,
        quantity: faultySim.quantity,
        dateTime: faultySim.dateTime,
        status: 'returned_to_company',
        notes: faultySim.notes,
      );
      
      await LocalStorageService.saveFaultySim(updatedSim);
      _faultySims[index] = updatedSim;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Return faulty SIM to inventory
  Future<bool> returnFaultyToInventory(String faultySimId) async {
    try {
      final index = _faultySims.indexWhere((sim) => sim.id == faultySimId);
      if (index == -1) return false;
      
      final faultySim = _faultySims[index];
      
      // Update faulty sim status
      final updatedSim = FaultySim(
        id: faultySim.id,
        userId: faultySim.userId,
        type: faultySim.type,
        quantity: faultySim.quantity,
        dateTime: faultySim.dateTime,
        status: 'returned_to_inventory',
        notes: faultySim.notes,
      );
      
      await LocalStorageService.saveFaultySim(updatedSim);
      _faultySims[index] = updatedSim;
      
      // Add back to inventory
      final transaction = InventoryTransaction(
        id: const Uuid().v4(),
        userId: userId,
        type: faultySim.type,
        quantity: faultySim.quantity,
        transactionType: 'returned',
        dateTime: DateTime.now(),
        notes: 'إرجاع شرائح معطلة للمخزون',
      );
      
      await LocalStorageService.saveInventoryTransaction(transaction);
      _transactions.add(transaction);
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Delete inventory transaction
  Future<bool> deleteTransaction(String id) async {
    try {
      await LocalStorageService.deleteInventoryTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Get pending faulty SIMs
  List<FaultySim> getPendingFaultySims() {
    return _faultySims.where((sim) => sim.status == 'pending').toList();
  }
}
