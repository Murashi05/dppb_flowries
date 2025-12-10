import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String _currentRole = '';
  String _currentUserName = '';
  final String _roleKey = 'user_role';
  final String _userNameKey = 'user_name';

  String get currentRole => _currentRole;
  String get currentUserName => _currentUserName;

  Future<void> initialize() async {
    await _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentRole = prefs.getString(_roleKey) ?? '';
      _currentUserName = prefs.getString(_userNameKey) ?? '';
    } catch (e) {
      print('Error loading auth: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_roleKey, _currentRole);
      await prefs.setString(_userNameKey, _currentUserName);
    } catch (e) {
      print('Error saving auth: $e');
    }
  }

  Future<bool> loginAdmin(String email, String password) async {
    if (email == "admin@gmail.com" && password == "admin123") {
      _currentRole = 'admin';
      _currentUserName = 'Admin';
      // Save to storage di background (non-blocking)
      _saveToStorage();
      return true;
    }
    return false;
  }

  Future<bool> loginCustomer(String email, String password) async {
    // Validasi sederhana untuk pembeli
    if (email.isNotEmpty && password.isNotEmpty && password.length >= 6) {
      _currentRole = 'customer';
      _currentUserName = email.split('@')[0];
      // Save to storage di background (non-blocking)
      _saveToStorage();
      return true;
    }
    return false;
  }

  Future<bool> registerAdmin({
    required String email,
    required String password,
    required String nama,
    required String noTelepon,
    required String alamat,
  }) async {
    // Simulasi register admin - dalam real app ini akan hit API
    if (email.isNotEmpty && password.length >= 6) {
      _currentRole = 'admin';
      _currentUserName = nama;
      // Save to storage di background (non-blocking)
      _saveToStorage();
      return true;
    }
    return false;
  }

  Future<bool> registerCustomer({
    required String email,
    required String password,
    required String nama,
    required String noTelepon,
    required String alamat,
  }) async {
    // Simulasi register pembeli - dalam real app ini akan hit API
    if (email.isNotEmpty && password.length >= 6) {
      _currentRole = 'customer';
      _currentUserName = nama;
      // Save to storage di background (non-blocking)
      _saveToStorage();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentRole = '';
    _currentUserName = '';
    // Save to storage di background (non-blocking)
    _saveToStorage();
  }

  bool isLoggedIn() => _currentRole.isNotEmpty;
  bool isAdmin() => _currentRole == 'admin';
  bool isCustomer() => _currentRole == 'customer';
}
