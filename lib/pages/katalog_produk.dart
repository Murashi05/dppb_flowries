import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/custom_navbar.dart';
import '../services/keranjang_service.dart';
import '../services/product_service.dart';

class KatalogProduk extends StatefulWidget {
  const KatalogProduk({super.key});

  @override
  State<KatalogProduk> createState() => _KatalogProdukState();
}

class _KatalogProdukState extends State<KatalogProduk> {
  int _currentNavIndex = 1; // Katalog is index 1
  final KeranjangService _keranjangService = KeranjangService();
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    await _productService.initialize();
    setState(() {});
  }

  void _handleNavigation(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/customer-home');
        break;
      case 1:
        // Already on katalog
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/keranjang');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  List<Product> get products => _productService.products;

  String searchQuery = '';
  String selectedSort = 'terbaru';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh produk setiap kali halaman ditampilkan
    _initializeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _productService,
        builder: (context, _) {
          final filteredProducts = products
              .where(
                (p) =>
                    p.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
                    p.deskripsi.toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              // Sort Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Text('Urutkan: '),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedSort,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'terbaru',
                            child: Text('Terbaru'),
                          ),
                          DropdownMenuItem(
                            value: 'termurah',
                            child: Text('Termurah'),
                          ),
                          DropdownMenuItem(
                            value: 'termahal',
                            child: Text('Termahal'),
                          ),
                          DropdownMenuItem(
                            value: 'rating',
                            child: Text('Rating Tertinggi'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Product List
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(child: Text('Produk tidak ditemukan'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              childAspectRatio: 0.7,
                            ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _buildProductGridCard(product);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentNavIndex,
        onIndexChanged: _handleNavigation,
      ),
    );
  }

  Widget _buildProductGridCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 3),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image - Larger (120px)
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail-produk',
                arguments: {
                  "id": product.id,
                  "nama": product.nama,
                  "deskripsi": product.deskripsi,
                  "gambar": product.gambar,
                  "harga": product.harga,
                  "stok": product.stok,
                  "rating": product.rating,
                  "jumlahUlasan": product.jumlahUlasan,
                },
              );
            },
            child: SizedBox(
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  child: Image.asset(
                    product.gambar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      final emojiMap = {
                        '1': '🌹',
                        '2': '🌷',
                        '3': '🌻',
                        '4': '🌸',
                        '5': '⚪',
                        '6': '💐',
                      };
                      return Container(
                        color: Colors.pink.shade100,
                        child: Center(
                          child: Text(
                            emojiMap[product.id] ?? '💐',
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Product Info - No spacer, tight layout
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 3, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Description (short)
                Text(
                  product.deskripsi,
                  style: const TextStyle(fontSize: 7, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Stock
                Text(
                  'Stok: ${product.stok}',
                  style: const TextStyle(
                    fontSize: 7,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                // Price
                Text(
                  'Rp ${(product.harga / 1000).toStringAsFixed(0)}K',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE91E63),
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 1),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, size: 8, color: Colors.amber),
                    const SizedBox(width: 1),
                    Text(
                      '${product.rating}',
                      style: const TextStyle(fontSize: 7),
                    ),
                    const SizedBox(width: 1),
                    Text(
                      '(${product.jumlahUlasan})',
                      style: const TextStyle(fontSize: 6, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                // Action Buttons - Bigger
                Row(
                  children: [
                    // Add to Cart Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _keranjangService.tambahKeKeranjang(
                            productId: product.id,
                            name: product.nama,
                            image: product.gambar,
                            price: product.harga.toInt(),
                            quantity: 1,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.nama} ditambahkan ke keranjang',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 12,
                            color: Color(0xFFE91E63),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 1),
                    // Detail Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-produk',
                            arguments: {
                              "id": product.id,
                              "nama": product.nama,
                              "deskripsi": product.deskripsi,
                              "gambar": product.gambar,
                              "harga": product.harga,
                              "stok": product.stok,
                              "rating": product.rating,
                              "jumlahUlasan": product.jumlahUlasan,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Detail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
  }
}
