// kelola_voucher_page.dart

import 'package:flutter/material.dart';
import '../models/voucher_model.dart';
import '../services/voucher_service.dart';

class KelolaVoucherPage extends StatefulWidget {
  const KelolaVoucherPage({super.key});

  @override
  State<KelolaVoucherPage> createState() => _KelolaVoucherPageState();
}

class _KelolaVoucherPageState extends State<KelolaVoucherPage> {
  final VoucherService _voucherService = VoucherService();

  @override
  void initState() {
    super.initState();
    _initializeVouchers();
  }

  Future<void> _initializeVouchers() async {
    await _voucherService.initialize();
    setState(() {});
  }

  List<Voucher> get vouchers => _voucherService.vouchers;

  void _showAddEditDialog({Voucher? voucher}) {
    final isEditMode = voucher != null;
    final titleController = TextEditingController(text: voucher?.title ?? '');
    final codeController = TextEditingController(text: voucher?.code ?? '');
    final amountController = TextEditingController(
      text: voucher?.discountAmount.toStringAsFixed(0) ?? '',
    );
    DateTime selectedDate = voucher?.validUntil ?? DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditMode ? 'Edit Voucher' : 'Tambah Voucher'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Voucher',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: 'Kode Voucher',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Diskon (Rp)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Berlaku Sampai',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    codeController.text.isNotEmpty &&
                    amountController.text.isNotEmpty) {
                  try {
                    if (isEditMode) {
                      await _voucherService.updateVoucher(
                        id: voucher.id,
                        title: titleController.text,
                        code: codeController.text,
                        discountAmount: double.parse(amountController.text),
                        validUntil: selectedDate,
                      );
                    } else {
                      await _voucherService.addVoucher(
                        title: titleController.text,
                        code: codeController.text,
                        discountAmount: double.parse(amountController.text),
                        validUntil: selectedDate,
                      );
                    }
                    if (mounted) {
                      Navigator.pop(context);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEditMode
                              ? 'Voucher berhasil diupdate'
                              : 'Voucher berhasil ditambahkan'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text(isEditMode ? 'Simpan' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Voucher'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _voucherService,
        builder: (context, _) {
          if (vouchers.isEmpty) {
            return const Center(
              child: Text('Belum ada voucher. Tambahkan voucher baru!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              final isExpired = voucher.validUntil.isBefore(DateTime.now());

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isExpired ? Colors.grey[200] : Colors.white,
                  border: Border.all(
                    color: isExpired ? Colors.grey[400]! : Colors.blue[300]!,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voucher.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isExpired ? Colors.grey : Colors.black,
                                  decoration: isExpired
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kode: ${voucher.code}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Diskon: Rp ${voucher.discountAmount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isExpired ? Colors.grey : Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Berlaku sampai: ${voucher.formattedDate}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isExpired ? Colors.red : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddEditDialog(voucher: voucher),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Hapus Voucher'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin menghapus voucher ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await _voucherService
                                              .deleteVoucher(voucher.id);
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Voucher dihapus'),
                                            ),
                                          );
                                        },
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isExpired)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Kadaluarsa',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}