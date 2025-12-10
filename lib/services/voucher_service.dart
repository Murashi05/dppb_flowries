import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/voucher_model.dart';

class VoucherService extends ChangeNotifier {
  static final VoucherService _instance = VoucherService._internal();
  factory VoucherService() => _instance;
  VoucherService._internal();

  List<Voucher> _vouchers = [];
  final String _storageKey = 'vouchers_data';

  List<Voucher> get vouchers => List.from(_vouchers);

  // Initialize from storage
  Future<void> initialize() async {
    await _loadFromStorage();
    
    // Jika pertama kali (storage kosong), isi dengan default vouchers
    if (_vouchers.isEmpty) {
      await _addDefaultVouchers();
    }
    
    // Notify listeners saat initialize selesai
    notifyListeners();
  }

  Future<void> addVoucher({
    required String title,
    required String code,
    required double discountAmount,
    required DateTime validUntil,
  }) async {
    final newVoucher = Voucher(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      code: code,
      discountAmount: discountAmount,
      validUntil: validUntil,
    );
    _vouchers.add(newVoucher);
    await _saveToStorage();
    notifyListeners();
    print('Voucher ditambahkan: $title');
  }

  Future<void> updateVoucher({
    required String id,
    required String title,
    required String code,
    required double discountAmount,
    required DateTime validUntil,
  }) async {
    final index = _vouchers.indexWhere((voucher) => voucher.id == id);
    if (index != -1) {
      _vouchers[index] = Voucher(
        id: id,
        title: title,
        code: code,
        discountAmount: discountAmount,
        validUntil: validUntil,
      );
      await _saveToStorage();
      notifyListeners();
      print('Voucher diupdate: $title');
    }
  }

  Future<void> deleteVoucher(String id) async {
    _vouchers.removeWhere((voucher) => voucher.id == id);
    await _saveToStorage();
    notifyListeners();
    print('Voucher dihapus dengan id: $id');
  }

  // Get valid vouchers only (not expired)
  List<Voucher> getValidVouchers() {
    return _vouchers
        .where((v) => v.validUntil.isAfter(DateTime.now()))
        .toList();
  }

  // Get voucher by code
  Voucher? getVoucherByCode(String code) {
    try {
      return _vouchers.firstWhere((v) => v.code.toUpperCase() == code.toUpperCase() && v.validUntil.isAfter(DateTime.now()));
    } catch (e) {
      return null;
    }
  }

  Voucher? getVoucherById(String id) {
    try {
      return _vouchers.firstWhere((voucher) => voucher.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _vouchers.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];
    _vouchers = jsonList
        .map((json) => Voucher.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _addDefaultVouchers() async {
    // Voucher 1: Diskon 20%
    _vouchers.add(
      Voucher(
        id: 'VOUCHER001',
        title: 'Diskon 20% untuk semua produk',
        code: 'DISKON20',
        discountAmount: 50000,
        validUntil: DateTime.now().add(const Duration(days: 30)),
      ),
    );

    // Voucher 2: Diskon 30%
    _vouchers.add(
      Voucher(
        id: 'VOUCHER002',
        title: 'Diskon Spesial 30% - Gratis ongkir',
        code: 'DISKON30',
        discountAmount: 75000,
        validUntil: DateTime.now().add(const Duration(days: 15)),
      ),
    );

    await _saveToStorage();
    notifyListeners();
    print('✅ Default vouchers ditambahkan');
  }
}
