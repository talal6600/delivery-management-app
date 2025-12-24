import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/local_storage.dart';
import '../config/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.role == AppConstants.roleAdmin;
  
  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final user = LocalStorageService.getUserByUsername(username);
      
      if (user == null) {
        _errorMessage = 'اسم المستخدم غير موجود';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      if (user.password != password) {
        _errorMessage = 'كلمة المرور غير صحيحة';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      if (!user.isActive) {
        _errorMessage = 'الحساب غير نشط';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      // Check subscription for delegates
      if (user.role == AppConstants.roleDelegate) {
        if (user.subscriptionEnd != null && user.subscriptionEnd!.isBefore(DateTime.now())) {
          _errorMessage = 'انتهت فترة الاشتراك';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
      
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // Logout
  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }
  
  // Add new delegate (admin only)
  Future<bool> addDelegate({
    required String username,
    required String password,
    required String displayName,
    required String subscriptionPeriod,
    required int subscriptionDuration,
  }) async {
    if (!isAdmin) {
      _errorMessage = 'غير مصرح لك بإضافة مندوبين';
      notifyListeners();
      return false;
    }
    
    try {
      // Check if username already exists
      try {
        LocalStorageService.getUserByUsername(username);
        _errorMessage = 'اسم المستخدم موجود بالفعل';
        notifyListeners();
        return false;
      } catch (e) {
        // Username doesn't exist, continue
      }
      
      // Calculate subscription end date
      DateTime subscriptionEnd;
      if (subscriptionPeriod == AppConstants.subscriptionWeek) {
        subscriptionEnd = DateTime.now().add(Duration(days: 7 * subscriptionDuration));
      } else {
        subscriptionEnd = DateTime.now().add(Duration(days: 30 * subscriptionDuration));
      }
      
      final newUser = User(
        id: 'delegate_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        password: password,
        displayName: displayName,
        role: AppConstants.roleDelegate,
        subscriptionEnd: subscriptionEnd,
        createdAt: DateTime.now(),
        isActive: true,
      );
      
      await LocalStorageService.saveUser(newUser);
      
      // Create default settings for the new user
      // This will be handled by the settings provider
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء إضافة المندوب';
      notifyListeners();
      return false;
    }
  }
  
  // Get all delegates (admin only)
  List<User> getDelegates() {
    if (!isAdmin) return [];
    
    return LocalStorageService.getAllUsers()
        .where((user) => user.role == AppConstants.roleDelegate)
        .toList();
  }
  
  // Update user
  Future<void> updateUser(User user) async {
    await LocalStorageService.saveUser(user);
    if (_currentUser?.id == user.id) {
      _currentUser = user;
    }
    notifyListeners();
  }
  
  // Delete delegate (admin only)
  Future<bool> deleteDelegate(String userId) async {
    if (!isAdmin) return false;
    
    try {
      await LocalStorageService.deleteUser(userId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
