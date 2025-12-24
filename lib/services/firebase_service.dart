import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';
import '../models/delivery.dart';
import '../models/inventory.dart';
import '../models/fuel.dart';
import '../models/settings.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  
  // Collections
  static const String _usersCollection = 'users';
  static const String _deliveriesCollection = 'deliveries';
  static const String _inventoryCollection = 'inventory';
  static const String _faultySimsCollection = 'faulty_sims';
  static const String _fuelCollection = 'fuel';
  static const String _settingsCollection = 'settings';
  
  // Authentication
  static Future<auth.User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
  static auth.User? get currentUser => _auth.currentUser;
  
  // User operations
  static Future<void> saveUser(User user) async {
    await _firestore
        .collection(_usersCollection)
        .doc(user.id)
        .set(user.toJson());
  }
  
  static Future<User?> getUser(String id) async {
    final doc = await _firestore
        .collection(_usersCollection)
        .doc(id)
        .get();
    
    if (doc.exists) {
      return User.fromJson(doc.data()!);
    }
    return null;
  }
  
  static Stream<List<User>> getAllUsersStream() {
    return _firestore
        .collection(_usersCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data()))
            .toList());
  }
  
  // Delivery operations
  static Future<void> saveDelivery(Delivery delivery) async {
    await _firestore
        .collection(_deliveriesCollection)
        .doc(delivery.id)
        .set(delivery.toJson());
  }
  
  static Stream<List<Delivery>> getDeliveriesByUserStream(String userId) {
    return _firestore
        .collection(_deliveriesCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Delivery.fromJson(doc.data()))
            .toList());
  }
  
  static Future<void> deleteDelivery(String id) async {
    await _firestore
        .collection(_deliveriesCollection)
        .doc(id)
        .delete();
  }
  
  // Inventory operations
  static Future<void> saveInventoryTransaction(InventoryTransaction transaction) async {
    await _firestore
        .collection(_inventoryCollection)
        .doc(transaction.id)
        .set(transaction.toJson());
  }
  
  static Stream<List<InventoryTransaction>> getInventoryByUserStream(String userId) {
    return _firestore
        .collection(_inventoryCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryTransaction.fromJson(doc.data()))
            .toList());
  }
  
  // Faulty SIM operations
  static Future<void> saveFaultySim(FaultySim faultySim) async {
    await _firestore
        .collection(_faultySimsCollection)
        .doc(faultySim.id)
        .set(faultySim.toJson());
  }
  
  static Stream<List<FaultySim>> getFaultySimsByUserStream(String userId) {
    return _firestore
        .collection(_faultySimsCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FaultySim.fromJson(doc.data()))
            .toList());
  }
  
  // Fuel operations
  static Future<void> saveFuelEntry(FuelEntry entry) async {
    await _firestore
        .collection(_fuelCollection)
        .doc(entry.id)
        .set(entry.toJson());
  }
  
  static Stream<List<FuelEntry>> getFuelEntriesByUserStream(String userId) {
    return _firestore
        .collection(_fuelCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FuelEntry.fromJson(doc.data()))
            .toList());
  }
  
  // Settings operations
  static Future<void> saveSettings(AppSettings settings) async {
    await _firestore
        .collection(_settingsCollection)
        .doc(settings.userId)
        .set(settings.toJson());
  }
  
  static Future<AppSettings?> getSettings(String userId) async {
    final doc = await _firestore
        .collection(_settingsCollection)
        .doc(userId)
        .get();
    
    if (doc.exists) {
      return AppSettings.fromJson(doc.data()!);
    }
    return null;
  }
  
  static Stream<AppSettings?> getSettingsStream(String userId) {
    return _firestore
        .collection(_settingsCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? AppSettings.fromJson(doc.data()!) : null);
  }
}
