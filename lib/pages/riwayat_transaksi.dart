import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class RiwayatTransaksiPage extends StatefulWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  final TransactionService _transactionService = TransactionService();
  String selectedStatus = 'semua';

  @override
  void initState() {
    super.initState();
    _transactionService.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Transaction> get filteredTransactions {
    final allTransactions = _transactionService.transactions;
    if (selectedStatus == 'semua') return allTransactions;
    return allTransactions.where((t) => t.status == selectedStatus).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      case 'menunggu':
        return Colors.blue;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'selesai':
        return 'Selesai ✓';
      case 'diproses':
        return 'Diproses ⏳';
      case 'menunggu':
        return 'Menunggu ⌛';
      case 'dibatalkan':
        return 'Dibatalkan ✕';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Status
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['semua', 'menunggu', 'diproses', 'selesai', 'dibatalkan']
                    .map((status) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(status),
                            selected: selectedStatus == status,
                            onSelected: (selected) {
                              setState(() {
                                selectedStatus = status;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),

          // Transaction List
          Expanded(
            child: ListenableBuilder(
              listenable: _transactionService,
              builder: (context, child) {
                return filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 60,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Tidak ada transaksi',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail-transaksi',
                                arguments: transaction,
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[200]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ID: ${transaction.id}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(transaction.status)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _getStatusLabel(transaction.status),
                                          style: TextStyle(
                                            color:
                                                _getStatusColor(transaction.status),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // DETAIL PRODUK YANG DIBELI
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Produk yang Dibeli:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...transaction.items.map((item) => Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Gambar produk dari assets
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: Colors.grey[100],
                                                ),
                                                child: item.productGambar.startsWith('assets/')
                                                    ? Image.asset(
                                                        item.productGambar,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Center(
                                                        child: Text(
                                                          item.productGambar,
                                                          style: const TextStyle(fontSize: 24),
                                                        ),
                                                      ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Detail produk
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.productNama,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      'Rp ${item.productHarga.toStringAsFixed(0)} x ${item.quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Subtotal
                                              Text(
                                                'Rp ${item.subtotal.toStringAsFixed(0)}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // RINGKASAN HARGA
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.pink[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Subtotal:',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                            Text(
                                              'Rp ${transaction.totalSebelomDiskon.toStringAsFixed(0)}',
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        if (transaction.diskonNominal > 0)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Diskon${transaction.voucherKode != null ? ' (${transaction.voucherKode})' : ''}:',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  Text(
                                                    '-Rp ${transaction.diskonNominal.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                            ],
                                          ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'Rp ${transaction.totalSetelahDiskon.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        transaction.tanggalPemesanan
                                            .toString()
                                            .split(' ')[0],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'Metode: ${transaction.metodePembayaran}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Pengiriman: ${transaction.alamatPengiriman}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  if (transaction.status == 'selesai')
                                    SizedBox(
                                      width: double.infinity,
                                      height: 35,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/tambah-ulasan',
                                            arguments: transaction,
                                          );
                                        },
                                        child: const Text(
                                          'Tambah Ulasan',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
