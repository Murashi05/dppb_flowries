// home_page.dart

import 'package:flutter/material.dart';
import 'voucher_model.dart';
import 'view_voucher_page.dart';
import 'kelola_voucher_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy Data Awal
  List<Voucher> vouchers = [
    Voucher(
      id: '1',
      title: 'Diskon Tahun Baru',
      code: 'NEWYEAR24',
      discountAmount: 50000,
      validUntil: DateTime(2024, 1, 1),
    ),
    Voucher(
      id: '2',
      title: 'Gratis Ongkir',
      code: 'FREESHIP',
      discountAmount: 15000,
      validUntil: DateTime(2024, 2, 14),
    ),
  ];

  // Navigasi ke halaman Tambah
  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const KelolaVoucherPage()),
    );

    if (result != null && result is Voucher) {
      setState(() {
        vouchers.add(result);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher berhasil ditambahkan!')),
      );
    }
  }

  // Navigasi ke halaman Detail
  void _navigateToDetail(Voucher voucher) async {
    // Kita menunggu result barangkali user melakukan edit di dalam halaman detail
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewVoucherPage(voucher: voucher),
      ),
    );

    if (result != null && result is Voucher) {
      // Update data di list jika ada perubahan (Edit)
      final index = vouchers.indexWhere((element) => element.id == result.id);
      if (index != -1) {
        setState(() {
          vouchers[index] = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Voucher'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: vouchers.isEmpty
          ? const Center(child: Text("Belum ada voucher"))
          : ListView.builder(
              itemCount: vouchers.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = vouchers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(
                        Icons.confirmation_number,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Code: ${item.code}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _navigateToDetail(item),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
