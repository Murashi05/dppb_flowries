import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UlasanService {
  static final UlasanService _instance = UlasanService._internal();
  factory UlasanService() => _instance;
  UlasanService._internal();

  List<Map<String, dynamic>> _ulasanList = [];
  final String _storageKey = 'ulasan_data';

  List<Map<String, dynamic>> get ulasanList => List.from(_ulasanList);

  Future<void> initialize() async {
    await _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ulasanJson = prefs.getString(_storageKey);

      if (ulasanJson != null) {
        final List<dynamic> ulasanListDynamic = json.decode(ulasanJson);
        _ulasanList = ulasanListDynamic
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      }
    } catch (e) {
      print('Error loading ulasan: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ulasanJson = json.encode(_ulasanList);
      await prefs.setString(_storageKey, ulasanJson);
    } catch (e) {
      print('Error saving ulasan: $e');
    }
  }

  Future<void> tambahUlasan({
    required String productId,
    required String nama,
    required String komentar,
    required int rating,
    required String gambar,
  }) async {
    final newUlasan = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "productId": productId,
      "nama": nama,
      "komentar": komentar,
      "rating": rating,
      "gambar": gambar,
      "tanggal": DateTime.now().toIso8601String(),
    };
    _ulasanList.add(newUlasan);
    await _saveToStorage();
  }

  List<Map<String, dynamic>> getUlasanByProductId(String productId) {
    return _ulasanList.where((ulasan) => ulasan["productId"] == productId).toList();
  }

  Future<void> hapusUlasan(String ulasanId) async {
    _ulasanList.removeWhere((ulasan) => ulasan["id"] == ulasanId);
    await _saveToStorage();
  }
}
