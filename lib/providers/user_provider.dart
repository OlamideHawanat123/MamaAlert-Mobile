import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasUser => _user != null;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user_data');
      
      if (userJson != null) {
        _user = UserModel.fromJson(json.decode(userJson));
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(user.toJson()));
      _user = user;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving user: $e');
    }
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    Role? role,
    bool? isActive,
  }) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
      isActive: isActive,
    );

    await saveUser(updatedUser);
  }

  // Get user's full name
  String? get fullName => _user?.fullName;

  // Get user's role
  Role? get role => _user?.role;

  // Check if user has specific role
  bool hasRole(Role role) => _user?.role == role;

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('auth_token');
      await prefs.remove('user_role');
      await prefs.remove('user_id');
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }
}
