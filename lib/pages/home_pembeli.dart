import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/voucher_model.dart';
import '../models/product_model.dart';
import '../widgets/custom_navbar.dart';
import '../services/keranjang_service.dart';
import '../services/voucher_service.dart';

class HomePembeli extends StatefulWidget {
  final User user;

  const HomePembeli({super.key, required this.user});

  @override
  State<HomePembeli> createState() => _HomePembeliState();
}

class _HomePembeliState extends State<HomePembeli> {
  int _currentNavIndex = 0;
  final KeranjangService _keranjangService = KeranjangService();
  final VoucherService _voucherService = VoucherService();

  @override
  void initState() {
    super.initState();
    _initializeVouchers();
  }

  Future<void> _initializeVouchers() async {
    try {
      await _voucherService.initialize();
      if (mounted) {
        setState(() {});
      }
      print('✅ Vouchers initialized: ${validVouchers.length} vouchers available');
    } catch (e) {
      print('❌ Error initializing vouchers: $e');
    }
  }

  List<Voucher> get validVouchers => _voucherService.getValidVouchers();

  late final List<Product> recommendedProducts = [
    Product(
      id: '1',
      nama: 'Bunga Mawar Merah',
      deskripsi: 'Bunga mawar merah segar berkualitas premium dari kebun pilihan',
      harga: 150000,
      stok: 25,
      gambar: 'assets/images/flower9.png',
      rating: 4.8,
      jumlahUlasan: 234,
      createdAt: DateTime.now(),
      createdBy: 'Flowries Team',
    ),
    Product(
      id: '2',
      nama: 'Bunga Tulip Kuning',
      deskripsi: 'Tulip kuning asli Belanda dengan keindahan alami',
      harga: 120000,
      stok: 30,
      gambar: 'assets/images/flower1.png',
      rating: 4.6,
      jumlahUlasan: 156,
      createdAt: DateTime.now(),
      createdBy: 'Flowries Team',
    ),
    Product(
      id: '3',
      nama: 'Bunga Matahari',
      deskripsi: 'Matahari cerah yang membawa kebahagiaan ke rumah Anda',
      harga: 100000,
      stok: 40,
      gambar: 'assets/images/flower3.png',
      rating: 4.7,
      jumlahUlasan: 189,
      createdAt: DateTime.now(),
      createdBy: 'Flowries Team',
    ),
    Product(
      id: '4',
      nama: 'Bunga Sakura',
      deskripsi: 'Sakura cantik yang melambangkan keindahan musim semi',
      harga: 130000,
      stok: 20,
      gambar: 'assets/images/flower5.png',
      rating: 4.9,
      jumlahUlasan: 267,
      createdAt: DateTime.now(),
      createdBy: 'Flowries Team',
    ),
  ];

  void _handleNavigation(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        // Home - stay on this page
        break;
      case 1:
        // Katalog
        Navigator.pushNamed(context, '/katalog');
        setState(() {
          _currentNavIndex = 0; // Reset ke home setelah navigate
        });
        break;
      case 2:
        // Keranjang
        Navigator.pushNamed(context, '/keranjang');
        setState(() {
          _currentNavIndex = 0;
        });
        break;
      case 3:
        // Riwayat
        Navigator.pushNamed(context, '/riwayat');
        setState(() {
          _currentNavIndex = 0;
        });
        break;
      case 4:
        // Profil
        Navigator.pushNamed(context, '/profil-pembeli');
        setState(() {
          _currentNavIndex = 0;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flowries Bouquet'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFE91E63), Color(0xFFC2185B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Selamat Datang! 👋',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.user.nama,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Temukan bunga segar untuk momen spesial Anda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sejarah Toko
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌸 Tentang Flowries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flowries Bouquet - Bunga Segar Pilihan Anda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sejak 2020, Flowries Bouquet berkomitmen menyediakan bunga segar berkualitas tinggi untuk setiap momen istimewa Anda. Dengan tim florist profesional, kami menciptakan rangkaian bunga yang indah dan bermakna.\n\n'
                          '✨ Bunga Segar Premium\n'
                          '🚚 Pengiriman Cepat & Aman\n'
                          '💝 Layanan Pelanggan 24/7\n'
                          '🎁 Kemasan Mewah',
                          style: TextStyle(fontSize: 12, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Featured Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFFB6D9), const Color(0xFFFFCDE6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '🎉 Penawaran Terbatas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dapatkan diskon hingga 50% untuk produk pilihan!',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/katalog');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Belanja Sekarang',
                              style: TextStyle(color: Color(0xFFE91E63)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text('🌹', style: TextStyle(fontSize: 80)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Produk Rekomendasi
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      '💐 Produk Rekomendasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedProducts.length,
                      itemBuilder: (context, index) {
                        final product = recommendedProducts[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 150,
                            child: _buildProductCard(product),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Voucher Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListenableBuilder(
                listenable: _voucherService,
                builder: (context, _) {
                  final voucherList = validVouchers;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎟️ Voucher & Promo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (voucherList.isEmpty)
                        const Center(
                          child: Text('Belum ada voucher tersedia'),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: voucherList.length,
                          itemBuilder: (context, index) {
                            final voucher = voucherList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.pink.shade300,
                                    Colors.pink.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          voucher.code,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          voucher.title,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Berlaku sampai ${voucher.formattedDate}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Kode ${voucher.code} disalin!',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Pakai',
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Why Choose Us
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⭐ Mengapa Memilih Flowries?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureItem(
                    icon: Icons.local_florist,
                    title: 'Bunga Segar Pilihan',
                    description: 'Dipilih dari kebun terbaik setiap hari',
                  ),
                  _buildFeatureItem(
                    icon: Icons.flash_on,
                    title: 'Pengiriman Cepat',
                    description: 'Sampai dalam 1-2 jam ke seluruh kota',
                  ),
                  _buildFeatureItem(
                    icon: Icons.verified_user,
                    title: 'Terjamin Kualitas',
                    description: 'Garansi uang kembali jika tidak puas',
                  ),
                  _buildFeatureItem(
                    icon: Icons.handshake,
                    title: 'Layanan Terbaik',
                    description: 'Customer service siap membantu 24/7',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentNavIndex,
        onIndexChanged: _handleNavigation,
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image - Clickable - Fixed height
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail-produk',
                arguments: product,
              );
            },
            child: SizedBox(
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
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
                      };
                      return Container(
                        color: Colors.pink.shade100,
                        child: Center(
                          child: Text(
                            emojiMap[product.id] ?? '💐',
                            style: const TextStyle(fontSize: 45),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Product Info - Fixed height
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28,
                        child: Text(
                          product.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 11, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating}',
                            style: const TextStyle(fontSize: 9),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '(${product.jumlahUlasan})',
                            style: const TextStyle(
                              fontSize: 8,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Rp ${(product.harga / 1000).toStringAsFixed(0)}K',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE91E63),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  // Action Buttons - Always at bottom
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
                                content: Text('${product.nama} ditambahkan ke keranjang'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.shopping_cart,
                              size: 13,
                              color: Color(0xFFE91E63),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Detail Button
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail-produk',
                              arguments: product,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE91E63),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Detail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
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
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.pink, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

