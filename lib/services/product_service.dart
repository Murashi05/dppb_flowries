import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  List<Product> _products = [];
  final String _storageKey = 'products_data';

  List<Product> get products => List.from(_products);

  // Initialize from storage
  Future<void> initialize() async {
    await _loadFromStorage();
    
    // Jika pertama kali, isi dengan data default
    if (_products.isEmpty) {
      _products = _getDefaultProducts();
      await _saveToStorage();
    }
  }

  List<Product> _getDefaultProducts() {
    return [
      Product(
        id: '1',
        nama: 'Bunga Mawar Merah',
        deskripsi: 'Rangkaian bunga mawar merah segar pilihan terbaik',
        harga: 150000,
        gambar: 'assets/images/flower1.png',
        stok: 20,
        rating: 4.8,
        jumlahUlasan: 45,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
      Product(
        id: '2',
        nama: 'Bunga Tulip Kuning',
        deskripsi: 'Rangkaian bunga tulip kuning cerah yang menyegarkan',
        harga: 120000,
        gambar: 'assets/images/flower2.png',
        stok: 15,
        rating: 4.6,
        jumlahUlasan: 32,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
      Product(
        id: '3',
        nama: 'Bunga Matahari',
        deskripsi: 'Bunga matahari besar dan indah untuk hadiah spesial',
        harga: 180000,
        gambar: 'assets/images/flower3.png',
        stok: 10,
        rating: 4.9,
        jumlahUlasan: 28,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
      Product(
        id: '4',
        nama: 'Bunga Sakura Pink',
        deskripsi: 'Rangkaian sakura pink yang romantis dan elegan',
        harga: 200000,
        gambar: 'assets/images/flower4.png',
        stok: 8,
        rating: 4.7,
        jumlahUlasan: 20,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
      Product(
        id: '5',
        nama: 'Bunga Lily Putih',
        deskripsi: 'Bunga lily putih berkualitas premium untuk acara formal',
        harga: 220000,
        gambar: 'assets/images/flower5.png',
        stok: 12,
        rating: 4.5,
        jumlahUlasan: 15,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
      Product(
        id: '6',
        nama: 'Mixed Bouquet',
        deskripsi: 'Rangkaian bunga mix berbagai jenis dan warna',
        harga: 250000,
        gambar: 'assets/images/flower6.png',
        stok: 5,
        rating: 4.9,
        jumlahUlasan: 52,
        createdAt: DateTime.now(),
        createdBy: 'admin@flowries.com',
      ),
    ];
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getString(_storageKey);
      
      if (productsJson != null) {
        final List<dynamic> productsList = json.decode(productsJson);
        _products = productsList.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading products: $e');
      _products = _getDefaultProducts();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = json.encode(_products.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, productsJson);
    } catch (e) {
      print('Error saving products: $e');
    }
  }

  Future<void> addProduct({
    required String nama,
    required String deskripsi,
    required double harga,
    required int stok,
    required String gambar,
  }) async {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: nama,
      deskripsi: deskripsi,
      harga: harga,
      stok: stok,
      gambar: gambar,
      createdAt: DateTime.now(),
      createdBy: 'admin@flowries.com',
    );
    _products.add(newProduct);
    await _saveToStorage();
    notifyListeners();
    print('Produk ditambahkan: $nama');
  }

  Future<void> updateProduct({
    required String id,
    required String nama,
    required String deskripsi,
    required double harga,
    required int stok,
    required String gambar,
  }) async {
    final index = _products.indexWhere((product) => product.id == id);
    if (index != -1) {
      _products[index] = Product(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        harga: harga,
        stok: stok,
        gambar: gambar,
        rating: _products[index].rating,
        jumlahUlasan: _products[index].jumlahUlasan,
        createdAt: _products[index].createdAt,
        createdBy: _products[index].createdBy,
      );
      await _saveToStorage();
      notifyListeners();
      print('Produk diupdate: $nama');
    }
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    await _saveToStorage();
    notifyListeners();
    print('Produk dihapus dengan id: $id');
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}