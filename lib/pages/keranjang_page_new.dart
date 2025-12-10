import 'package:flutter/material.dart';
import '../services/keranjang_service.dart';
import '../widgets/custom_navbar.dart';

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({super.key});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final KeranjangService _keranjangService = KeranjangService();
  int _currentNavIndex = 2; // Index untuk keranjang

  void _handleNavigation(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/customer-home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/katalog');
        break;
      case 2:
        // Already on keranjang
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  void _removeItem(String productId) {
    _keranjangService.hapusItem(productId);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item dihapus dari keranjang')),
    );
  }

  void _updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(productId);
      return;
    }
    _keranjangService.updateQuantity(productId, newQuantity);
    setState(() {});
  }

  void _toggleItemSelection(String productId, bool value) {
    final item = _keranjangService.keranjangItems
        .firstWhere((item) => item.productId == productId);
    item.isSelected = value;
    setState(() {});
  }

  double get _totalHarga {
    return _keranjangService.keranjangItems
        .where((item) => item.isSelected)
        .fold(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );
  }

  Widget _buildProductImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.pink.shade100,
          child: Center(
            child: Text(
              '💐',
              style: TextStyle(fontSize: 40),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keranjangItems = _keranjangService.keranjangItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
      ),
      body: Column(
        children: [
          Expanded(
            child: keranjangItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Keranjang Anda Kosong',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/katalog');
                          },
                          child: const Text('Belanja Sekarang'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: keranjangItems.length,
                    itemBuilder: (context, index) {
                      final item = keranjangItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox
                            Checkbox(
                              value: item.isSelected,
                              onChanged: (value) {
                                _toggleItemSelection(item.productId, value ?? false);
                              },
                            ),
                            // Gambar Produk
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.pink.shade100,
                              ),
                              child: _buildProductImage(item.image),
                            ),
                            const SizedBox(width: 12),
                            // Info Produk
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${(item.price / 1000).toStringAsFixed(0)}K',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Subtotal: Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Quantity Controls
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey[300]!,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _updateQuantity(
                                                  item.productId,
                                                  item.quantity - 1,
                                                );
                                              },
                                              icon: const Icon(Icons.remove,
                                                  size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 24,
                                              child: Center(
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _updateQuantity(
                                                  item.productId,
                                                  item.quantity + 1,
                                                );
                                              },
                                              icon:
                                                  const Icon(Icons.add, size: 16),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(
                                                minWidth: 30,
                                                minHeight: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Delete Button
                                      IconButton(
                                        onPressed: () {
                                          _removeItem(item.productId);
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (keranjangItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${_totalHarga.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/katalog');
                          },
                          child: const Text('Lanjut Belanja'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/pembayaran',
                              arguments: {
                                'items': keranjangItems,
                                'total': _totalHarga,
                              },
                            );
                          },
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentNavIndex,
        onIndexChanged: _handleNavigation,
      ),
    );
  }
}
