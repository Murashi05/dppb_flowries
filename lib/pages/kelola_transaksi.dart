import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class KelolaTransaksi extends StatefulWidget {
  const KelolaTransaksi({super.key});

  @override
  State<KelolaTransaksi> createState() => _KelolaTransaksiState();
}

class _KelolaTransaksiState extends State<KelolaTransaksi> {
  final transactionService = TransactionService();
  String selectedStatus = 'semua';

  @override
  void initState() {
    super.initState();
    transactionService.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  List<Transaction> get filteredTransactions {
    final allTransactions = transactionService.transactions;
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

  void _updateStatus(Transaction transaction, String newStatus) {
    transactionService.updateTransactionStatus(
      transactionId: transaction.id,
      newStatus: newStatus,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status diubah menjadi $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Transaksi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['semua', 'menunggu', 'diproses', 'selesai']
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
          Expanded(
            child: ListenableBuilder(
              listenable: transactionService,
              builder: (context, child) {
                return filteredTransactions.isEmpty
                    ? const Center(
                        child: Text('Tidak ada transaksi'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return Container(
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
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                                transaction.status)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        transaction.status,
                                        style: TextStyle(
                                          color: _getStatusColor(
                                              transaction.status),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  transaction.items
                                      .map((item) => item.productNama)
                                      .join(', '),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rp ${transaction.totalSetelahDiskon.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    Text(
                                      transaction.metodePembayaran,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                if (transaction.status != 'selesai')
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    value: ['menunggu', 'diproses', 'selesai', 'dibatalkan']
                                        .contains(transaction.status)
                                        ? transaction.status
                                        : 'menunggu',
                                    items: ['menunggu', 'diproses', 'selesai', 'dibatalkan']
                                        .map((status) =>
                                            DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ))
                                        .toList(),
                                    onChanged: (newStatus) {
                                      if (newStatus != null) {
                                        _updateStatus(transaction,
                                            newStatus);
                                      }
                                    },
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
    );
  }
}
