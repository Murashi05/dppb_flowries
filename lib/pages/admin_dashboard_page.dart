import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AdminDashboardPage extends StatefulWidget {
  final User user;

  const AdminDashboardPage({super.key, required this.user});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late User user;
  int totalProduk = 6;
  int totalTransaksi = 128;
  double totalPenjualan = 5250000;
  int totalPembeli = 45;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Apakah Anda yakin ingin logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCDE6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang, ${user.nama}! 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Kelola aplikasi Flowries Bouquet Anda di sini',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Statistics Cards
            const Text(
              'Statistik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildStatCard(
                  icon: Icons.shopping_bag,
                  label: 'Produk',
                  value: totalProduk.toString(),
                  color: Colors.blue,
                ),
                _buildStatCard(
                  icon: Icons.receipt,
                  label: 'Transaksi',
                  value: totalTransaksi.toString(),
                  color: Colors.green,
                ),
                _buildStatCard(
                  icon: Icons.attach_money,
                  label: 'Total Penjualan',
                  value: 'Rp ${(totalPenjualan / 1000000).toStringAsFixed(1)}M',
                  color: Colors.orange,
                ),
                _buildStatCard(
                  icon: Icons.people,
                  label: 'Total Pembeli',
                  value: totalPembeli.toString(),
                  color: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Menu Options
            const Text(
              'Menu Administrasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildMenuOption(
              icon: Icons.inventory_2,
              label: 'Kelola Produk',
              description: 'Tambah, edit, atau hapus produk',
              color: Colors.pink,
              onTap: () {
                Navigator.pushNamed(context, '/kelola-produk');
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              icon: Icons.local_offer,
              label: 'Kelola Voucher',
              description: 'Buat dan kelola voucher diskon',
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/kelola-voucher');
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              icon: Icons.receipt_long,
              label: 'Kelola Transaksi',
              description: 'Lihat dan proses transaksi pembeli',
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/kelola-transaksi');
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              icon: Icons.star_rate,
              label: 'Lihat Ulasan',
              description: 'Pantau ulasan dan rating produk',
              color: Colors.amber,
              onTap: () {
                Navigator.pushNamed(context, '/lihat-ulasan');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
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
            Icon(Icons.arrow_forward, color: color),
          ],
        ),
      ),
    );
  }
}
