import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userRole;
  String? _userName;
  int? _userId;
  bool _isAuthenticated = false;

  String? get token => _token;
  String? get userRole => _userRole;
  String? get userName => _userName;
  int? get userId => _userId;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      _userRole = prefs.getString('user_role');
      _userName = prefs.getString('user_name');
      _userId = prefs.getInt('user_id');
      
      _isAuthenticated = _token != null && _userRole != null;
      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> saveUserData({
    required String token,
    required String role,
    required String name,
    required int id,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_role', role);
      await prefs.setString('user_name', name);
      await prefs.setInt('user_id', id);

      _token = token;
      _userRole = role;
      _userName = name;
      _userId = id;
      _isAuthenticated = true;
      
      notifyListeners();
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _token = null;
      _userRole = null;
      _userName = null;
      _userId = null;
      _isAuthenticated = false;
      
      notifyListeners();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  bool hasRole(String role) {
    return _userRole?.toLowerCase() == role.toLowerCase();
  }
}
