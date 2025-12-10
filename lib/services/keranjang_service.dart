// services/keranjang_service.dart
import '../models/keranjang_model.dart';

class KeranjangService {
  static final KeranjangService _instance = KeranjangService._internal();
  factory KeranjangService() => _instance;
  KeranjangService._internal();

  List<KeranjangItem> _keranjangItems = [];

  List<KeranjangItem> get keranjangItems => _keranjangItems;

  void tambahKeKeranjang({
    required String productId,
    required String name,
    required String image,
    required int price,
    int quantity = 1,
  }) {
    // Cek apakah produk sudah ada di keranjang
    final existingIndex = _keranjangItems.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex >= 0) {
      // Jika sudah ada, update quantity
      _keranjangItems[existingIndex].quantity += quantity;
    } else {
      // Jika belum ada, tambah item baru
      final newItem = KeranjangItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        name: name,
        image: image,
        price: price,
        quantity: quantity,
      );
      _keranjangItems.add(newItem);
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _keranjangItems.indexWhere(
      (item) => item.productId == productId,
    );
    if (index >= 0 && newQuantity > 0) {
      _keranjangItems[index].quantity = newQuantity;
    }
  }

  void hapusItem(String productId) {
    _keranjangItems.removeWhere((item) => item.productId == productId);
  }

  void clearKeranjang() {
    _keranjangItems.clear();
  }

  int get totalHarga {
    return _keranjangItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.total);
  }

  int get jumlahItemDipilih {
    return _keranjangItems.where((item) => item.isSelected).length;
  }

  void toggleSelectAll(bool value) {
    for (var item in _keranjangItems) {
      item.isSelected = value;
    }
  }

  void toggleSelectItem(String productId, bool value) {
    final index = _keranjangItems.indexWhere(
      (item) => item.productId == productId,
    );
    if (index >= 0) {
      _keranjangItems[index].isSelected = value;
    }
  }
}