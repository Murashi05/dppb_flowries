import 'package:flutter/material.dart';
import '../services/keranjang_service.dart';
import '../services/ulasan_service.dart';
import '../widgets/custom_navbar.dart';

class DetailProdukPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const DetailProdukPage({super.key, required this.product});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  int jumlah = 1;
  int _currentNavIndex = 1; // Index untuk katalog
  final KeranjangService keranjangService = KeranjangService();
  final UlasanService ulasanService = UlasanService();

  void _handleNavigation(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/customer-home');
        break;
      case 1:
        // Already on detail produk (katalog section)
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

  void _tambahKeKeranjang() {
    keranjangService.tambahKeKeranjang(
      productId: widget.product["id"],
      name: widget.product["nama"],
      image: widget.product["gambar"],
      price: widget.product["harga"],
      quantity: jumlah,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product["nama"]} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            Navigator.pushNamed(context, '/keranjang');
          },
        ),
      ),
    );
  }

  void _checkout() {
    final totalPembayaran = jumlah * widget.product["harga"];

    Navigator.pushNamed(
      context,
      '/pembayaran',
      arguments: {
        "type": "single",
        "product": widget.product,
        "quantity": jumlah,
        "total": totalPembayaran,
      },
    );
  }

  void _tambahKeKeranjangProdukLain(Map<String, dynamic> product) {
    keranjangService.tambahKeKeranjang(
      productId: product["id"],
      name: product["nama"],
      image: product["gambar"],
      price: (product["harga"] as num).toInt(),
      quantity: 1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["nama"]} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product["nama"]),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------- GAMBAR + DETAIL -------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GAMBAR
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      product["gambar"],
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // DETAIL
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product["nama"],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product["deskripsi"] ?? "Deskripsi tidak tersedia",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Harga: Rp ${product["harga"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // JUMLAH (+ -)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (jumlah > 1) jumlah--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            "$jumlah",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                jumlah++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            "${product["rating"] ?? "0.0"} (${product["jumlahUlasan"] ?? "0"})",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // TOMBOL KERANJANG & CHECKOUT
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: _tambahKeKeranjang,
                              child: const Text("Keranjang"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: _checkout,
                              child: const Text("Checkout"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // ------------------- ULASAN -------------------
            const Text(
              "Ulasan Pembeli",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                final ulasanList = ulasanService.getUlasanByProductId(
                  product["nama"],
                );
                if (ulasanList.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Belum ada ulasan untuk produk ini",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return Column(
                  children: ulasanList.map((ulasan) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              ulasan["gambar"],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Icon(Icons.person),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Nama, komentar, bintang
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ulasan["nama"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ulasan["komentar"],
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      i < ulasan["rating"]
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
            // ------------------- PRODUK LAINNYA -------------------
            const Text(
              "Produk Lainnya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 260,
              child: Builder(
                builder: (context) {
                  final produkLainnya = [
                    {
                      "id": "1",
                      "nama": "Bunga Mawar Merah",
                      "deskripsi":
                          "Rangkaian bunga mawar merah segar pilihan terbaik",
                      "gambar": "assets/images/flower1.png",
                      "harga": 150000,
                      "stok": 20,
                      "rating": 4.8,
                      "jumlahUlasan": 45,
                    },
                    {
                      "id": "2",
                      "nama": "Bunga Tulip Kuning",
                      "deskripsi":
                          "Rangkaian bunga tulip kuning cerah yang menyegarkan",
                      "gambar": "assets/images/flower2.png",
                      "harga": 120000,
                      "stok": 15,
                      "rating": 4.6,
                      "jumlahUlasan": 32,
                    },
                    {
                      "id": "3",
                      "nama": "Bunga Matahari",
                      "deskripsi":
                          "Bunga matahari besar dan indah untuk hadiah spesial",
                      "gambar": "assets/images/flower3.png",
                      "harga": 180000,
                      "stok": 10,
                      "rating": 4.9,
                      "jumlahUlasan": 28,
                    },
                    {
                      "id": "4",
                      "nama": "Bunga Sakura Pink",
                      "deskripsi":
                          "Rangkaian sakura pink yang romantis dan elegan",
                      "gambar": "assets/images/flower4.png",
                      "harga": 200000,
                      "stok": 8,
                      "rating": 4.7,
                      "jumlahUlasan": 20,
                    },
                  ];

                  if (produkLainnya.isEmpty) {
                    return const Center(child: Text("Tidak ada produk lain"));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: produkLainnya.length,
                    itemBuilder: (context, index) {
                      final item = produkLainnya[index];
                      return Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  item["gambar"] as String, 
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    final emojiMap = {
                                      "1": "🌹",
                                      "2": "🌷",
                                      "3": "🌻",
                                      "4": "🌸",
                                    };
                                    return Container(
                                      color: Colors.pink.shade100,
                                      child: Center(
                                        child: Text(
                                          emojiMap[item["id"]] ?? "💐",
                                          style: const TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["nama"] as String,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp ${item["harga"]}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  Text(
                                    "Stok: ${item["stok"]}",
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Row tombol dengan ikon
                                  Row(
                                    children: [
                                      // Tombol Detail
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailProdukPage(
                                                  product: item,
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black87,
                                            minimumSize: const Size(0, 28),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.info_outline,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      // Tombol Keranjang
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              _tambahKeKeranjangProdukLain(
                                            item,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pink,
                                            minimumSize: const Size(0, 28),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.shopping_cart,
                                            size: 12,
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
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // NAVBAR - TAMBAHKAN INI
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentNavIndex,
        onIndexChanged: _handleNavigation,
      ),
    );
  }
}