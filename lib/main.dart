import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_pembeli.dart';
import 'pages/katalog_produk.dart';
import 'pages/detail_produk_page.dart';
import 'pages/keranjang_page_new.dart';
import 'pages/pembayaran_page_new.dart';
import 'pages/riwayat_transaksi.dart';
import 'pages/tambah_ulasan_page.dart';
import 'pages/profil_pembeli.dart';
import 'pages/daftar_ulasan.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/kelola_produk.dart';
import 'pages/kelola_voucher.dart';
import 'pages/kelola_transaksi.dart';
import 'pages/lihat_ulasan.dart';
import 'models/user_model.dart';
import 'models/transaction_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlowriesApp());
}

class FlowriesApp extends StatelessWidget {
  const FlowriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flowries Bouquet",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFCDE6),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      onGenerateRoute: (settings) {
        // Routes untuk Pembeli
        if (settings.name == '/home-pembeli') {
          final args = settings.arguments as Map<String, dynamic>?;
          final user = User(
            id: '1',
            email: args?['email'] ?? 'pembeli@flowries.com',
            password: 'password123',
            nama: args?['nama'] ?? 'Pembeli',
            noTelepon: '081234567890',
            alamat: 'Jl. Merdeka No. 123',
            tipeUser: 'pembeli',
            createdAt: DateTime.now(),
          );
          return MaterialPageRoute(
            builder: (context) => HomePembeli(user: user),
          );
        }
        if (settings.name == '/katalog') {
          return MaterialPageRoute(
            builder: (context) => const KatalogProduk(),
          );
        }
        if (settings.name == '/detail-produk') {
          final product = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => DetailProdukPage(product: product as dynamic),
          );
        }
        if (settings.name == '/keranjang') {
          return MaterialPageRoute(
            builder: (context) => const KeranjangPage(),
          );
        }
        if (settings.name == '/pembayaran') {
          return MaterialPageRoute(
            builder: (context) => const PembayaranPage(),
          );
        }
        if (settings.name == '/riwayat') {
          return MaterialPageRoute(
            builder: (context) => const RiwayatTransaksiPage(),
          );
        }
        if (settings.name == '/tambah-ulasan') {
          final transaction = settings.arguments as Transaction;
          return MaterialPageRoute(
            builder: (context) => TambahUlasanPage(transaction: transaction),
          );
        }
        if (settings.name == '/profil-pembeli') {
          final user = settings.arguments as User?;
          return MaterialPageRoute(
            builder: (context) => ProfilPembeli(
              user: user ??
                  User(
                    id: '1',
                    email: 'pembeli@flowries.com',
                    password: 'password123',
                    nama: 'Pembeli Test',
                    noTelepon: '081234567890',
                    alamat: 'Jl. Merdeka No. 123',
                    tipeUser: 'pembeli',
                    createdAt: DateTime.now(),
                  ),
            ),
          );
        }
        if (settings.name == '/daftar-ulasan') {
          return MaterialPageRoute(
            builder: (context) => const DaftarUlasanPage(),
          );
        }

        // Routes untuk Admin
        if (settings.name == '/admin-dashboard') {
          final args = settings.arguments as Map<String, dynamic>?;
          final user = User(
            id: '1',
            email: args?['email'] ?? 'admin@flowries.com',
            password: 'admin123',
            nama: args?['nama'] ?? 'Admin',
            noTelepon: '081234567890',
            alamat: 'Jl. Merdeka No. 123',
            tipeUser: 'admin',
            createdAt: DateTime.now(),
          );
          return MaterialPageRoute(
            builder: (context) => AdminDashboardPage(user: user),
          );
        }
        if (settings.name == '/kelola-produk') {
          return MaterialPageRoute(
            builder: (context) => const KelolaProduk(),
          );
        }
        if (settings.name == '/kelola-voucher') {
          return MaterialPageRoute(
            builder: (context) => const KelolaVoucherPage(),
          );
        }
        if (settings.name == '/kelola-transaksi') {
          return MaterialPageRoute(
            builder: (context) => const KelolaTransaksi(),
          );
        }
        if (settings.name == '/lihat-ulasan') {
          return MaterialPageRoute(
            builder: (context) => const LihatUlasan(),
          );
        }

        return null;
      },
    );
  }
}