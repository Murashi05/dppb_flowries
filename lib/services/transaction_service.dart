import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/transaction_model.dart';
import '../models/cart_model.dart';

class TransactionService extends ChangeNotifier {
  static final TransactionService _instance = TransactionService._internal();
  factory TransactionService() => _instance;
  TransactionService._internal();

  List<Transaction> _transactions = [];
  final String _storageKey = 'transactions_data';

  List<Transaction> get transactions => List.from(_transactions);

  // Initialize from storage
  Future<void> initialize() async {
    await _loadFromStorage();
    
    // Jika pertama kali (storage kosong), isi dengan default data
    if (_transactions.isEmpty) {
      await _addDefaultTransactions();
    }
  }

  Future<void> addTransaction({
    required String userId,
    required List<CartItem> items,
    required double totalSebelumDiskon,
    required double diskonNominal,
    required double totalSetelahDiskon,
    required String voucherId,
    required String? voucherKode,
    required String status,
    required DateTime tanggalPemesanan,
    required String metodePembayaran,
    required String alamatPengiriman,
  }) async {
    final newTransaction = Transaction(
      id: 'TRX${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      items: items,
      totalSebelomDiskon: totalSebelumDiskon,
      diskonNominal: diskonNominal,
      totalSetelahDiskon: totalSetelahDiskon,
      voucherId: voucherId,
      voucherKode: voucherKode,
      status: status,
      tanggalPemesanan: tanggalPemesanan,
      tanggalSelesai: null,
      metodePembayaran: metodePembayaran,
      alamatPengiriman: alamatPengiriman,
    );
    _transactions.add(newTransaction);
    await _saveToStorage();
    notifyListeners();
    print('Transaksi ditambahkan: ${newTransaction.id}');
  }

  Future<void> updateTransactionStatus({
    required String transactionId,
    required String newStatus,
  }) async {
    try {
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        final transaction = _transactions[index];
        _transactions[index] = Transaction(
          id: transaction.id,
          userId: transaction.userId,
          items: transaction.items,
          totalSebelomDiskon: transaction.totalSebelomDiskon,
          diskonNominal: transaction.diskonNominal,
          totalSetelahDiskon: transaction.totalSetelahDiskon,
          voucherId: transaction.voucherId,
          voucherKode: transaction.voucherKode,
          status: newStatus,
          tanggalPemesanan: transaction.tanggalPemesanan,
          tanggalSelesai: newStatus == 'selesai' ? DateTime.now() : transaction.tanggalSelesai,
          metodePembayaran: transaction.metodePembayaran,
          alamatPengiriman: transaction.alamatPengiriman,
        );
        await _saveToStorage();
        notifyListeners();
        print('✅ Status transaksi $transactionId diubah menjadi $newStatus');
      }
    } catch (e) {
      print('❌ Error update status: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((trx) => trx.id == id);
    await _saveToStorage();
    notifyListeners();
    print('Transaksi dihapus: $id');
  }

  // Get transactions by user ID (for pembeli riwayat)
  List<Transaction> getTransactionsByUserId(String userId) {
    return _transactions
        .where((trx) => trx.userId == userId)
        .toList()
        .reversed
        .toList(); // Latest first
  }

  Transaction? getTransactionById(String id) {
    try {
      return _transactions.firstWhere((trx) => trx.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get summary stats
  Map<String, int> getTransactionStats() {
    return {
      'total': _transactions.length,
      'menunggu': _transactions.where((t) => t.status == 'menunggu').length,
      'diproses': _transactions.where((t) => t.status == 'diproses').length,
      'dikirim': _transactions.where((t) => t.status == 'dikirim').length,
      'selesai': _transactions.where((t) => t.status == 'selesai').length,
      'dibatalkan': _transactions.where((t) => t.status == 'dibatalkan').length,
    };
  }

  // Private methods untuk persistence
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _transactions
        .map((t) => jsonEncode(_transactionToJson(t)))
        .toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];
    _transactions = jsonList
        .map((json) => _jsonToTransaction(jsonDecode(json)))
        .toList();
  }

  Future<void> _addDefaultTransactions() async {
    _transactions = [
      Transaction(
        id: 'TRX001',
        userId: '1',
        items: [
          CartItem(
            id: '1',
            productId: '1',
            productNama: 'Bunga Mawar Merah',
            productHarga: 150000,
            productGambar: 'assets/images/flower9.png',
            quantity: 2,
          ),
        ],
        totalSebelomDiskon: 300000,
        diskonNominal: 60000,
        totalSetelahDiskon: 240000,
        voucherId: '1',
        voucherKode: 'DISKON20',
        status: 'selesai',
        tanggalPemesanan: DateTime.now().subtract(const Duration(days: 5)),
        tanggalSelesai: DateTime.now().subtract(const Duration(days: 3)),
        metodePembayaran: 'Transfer Bank',
        alamatPengiriman: 'Jl. Merdeka No. 123, Jakarta',
      ),
      Transaction(
        id: 'TRX002',
        userId: '1',
        items: [
          CartItem(
            id: '2',
            productId: '2',
            productNama: 'Bunga Tulip Kuning',
            productHarga: 120000,
            productGambar: 'assets/images/flower8.png',
            quantity: 1,
          ),
        ],
        totalSebelomDiskon: 120000,
        diskonNominal: 0,
        totalSetelahDiskon: 120000,
        voucherId: '',
        voucherKode: null,
        status: 'dikirim',
        tanggalPemesanan: DateTime.now().subtract(const Duration(days: 2)),
        tanggalSelesai: null,
        metodePembayaran: 'E-Wallet',
        alamatPengiriman: 'Jl. Ahmad Yani No. 456, Bandung',
      ),
    ];
    await _saveToStorage();
  }

  // Helper methods untuk serialization
  Map<String, dynamic> _transactionToJson(Transaction t) {
    return {
      'id': t.id,
      'userId': t.userId,
      'items': t.items.map((item) => _cartItemToJson(item)).toList(),
      'totalSebelomDiskon': t.totalSebelomDiskon,
      'diskonNominal': t.diskonNominal,
      'totalSetelahDiskon': t.totalSetelahDiskon,
      'voucherId': t.voucherId,
      'voucherKode': t.voucherKode,
      'status': t.status,
      'tanggalPemesanan': t.tanggalPemesanan.toIso8601String(),
      'tanggalSelesai': t.tanggalSelesai?.toIso8601String(),
      'metodePembayaran': t.metodePembayaran,
      'alamatPengiriman': t.alamatPengiriman,
    };
  }

  Transaction _jsonToTransaction(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => _jsonToCartItem(item as Map<String, dynamic>))
          .toList(),
      totalSebelomDiskon: (json['totalSebelomDiskon'] as num).toDouble(),
      diskonNominal: (json['diskonNominal'] as num).toDouble(),
      totalSetelahDiskon: (json['totalSetelahDiskon'] as num).toDouble(),
      voucherId: json['voucherId'] as String,
      voucherKode: json['voucherKode'] as String?,
      status: json['status'] as String,
      tanggalPemesanan: DateTime.parse(json['tanggalPemesanan'] as String),
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'] as String)
          : null,
      metodePembayaran: json['metodePembayaran'] as String,
      alamatPengiriman: json['alamatPengiriman'] as String,
    );
  }

  Map<String, dynamic> _cartItemToJson(CartItem item) {
    return {
      'id': item.id,
      'productId': item.productId,
      'productNama': item.productNama,
      'productHarga': item.productHarga,
      'productGambar': item.productGambar,
      'quantity': item.quantity,
    };
  }

  CartItem _jsonToCartItem(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productNama: json['productNama'] as String,
      productHarga: (json['productHarga'] as num).toDouble(),
      productGambar: json['productGambar'] as String,
      quantity: json['quantity'] as int,
    );
  }
}
