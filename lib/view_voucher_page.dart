// view_voucher_page.dart

import 'package:flutter/material.dart';
import 'voucher_model.dart';
import 'kelola_voucher_page.dart';

class ViewVoucherPage extends StatefulWidget {
  final Voucher voucher;

  const ViewVoucherPage({super.key, required this.voucher});

  @override
  State<ViewVoucherPage> createState() => _ViewVoucherPageState();
}

class _ViewVoucherPageState extends State<ViewVoucherPage> {
  late Voucher currentVoucher;

  @override
  void initState() {
    super.initState();
    currentVoucher = widget.voucher;
  }

  void _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KelolaVoucherPage(voucher: currentVoucher),
      ),
    );

    if (result != null && result is Voucher) {
      setState(() {
        currentVoucher = result;
      });
      // Opsional: Kirim balik data yang baru ke Home agar list terupdate
      // Namun untuk demo ini, update visual di halaman ini sudah cukup,
      // nanti saat tombol 'Back' ditekan manual, kita kirim data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Pastikan saat back button ditekan, data terbaru dikirim ke Home
      onWillPop: () async {
        Navigator.pop(context, currentVoucher);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Detail Voucher')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        "Judul",
                        currentVoucher.title,
                        isBold: true,
                      ),
                      const Divider(),
                      _buildDetailRow("Kode Voucher", currentVoucher.code),
                      const Divider(),
                      _buildDetailRow(
                        "Diskon",
                        "Rp ${currentVoucher.discountAmount.toStringAsFixed(0)}",
                      ),
                      const Divider(),
                      _buildDetailRow(
                        "Berlaku Sampai",
                        currentVoucher.formattedDate,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _navigateToEdit,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Voucher"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
