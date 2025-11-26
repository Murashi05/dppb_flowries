// kelola_voucher_page.dart

import 'package:flutter/material.dart';
import 'voucher_model.dart';

class KelolaVoucherPage extends StatefulWidget {
  final Voucher? voucher; // Jika null = Mode Tambah, Jika ada = Mode Edit

  const KelolaVoucherPage({super.key, this.voucher});

  @override
  State<KelolaVoucherPage> createState() => _KelolaVoucherPageState();
}

class _KelolaVoucherPageState extends State<KelolaVoucherPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _titleController;
  late TextEditingController _codeController;
  late TextEditingController _amountController;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller berdasarkan mode
    if (widget.voucher != null) {
      // Mode Edit
      _titleController = TextEditingController(text: widget.voucher!.title);
      _codeController = TextEditingController(text: widget.voucher!.code);
      _amountController = TextEditingController(
        text: widget.voucher!.discountAmount.toStringAsFixed(0),
      );
      _selectedDate = widget.voucher!.validUntil;
    } else {
      // Mode Tambah
      _titleController = TextEditingController();
      _codeController = TextEditingController();
      _amountController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveVoucher() {
    if (_formKey.currentState!.validate()) {
      // Simulasi ID sederhana
      final String id =
          widget.voucher?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final newVoucher = Voucher(
        id: id,
        title: _titleController.text,
        code: _codeController.text,
        discountAmount: double.tryParse(_amountController.text) ?? 0,
        validUntil: _selectedDate,
      );

      // Print ke console sesuai request
      print("Menyimpan Voucher: ${newVoucher.title} (${newVoucher.code})");

      // Kembali ke halaman sebelumnya membawa data
      Navigator.pop(context, newVoucher);
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.voucher != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Voucher" : "Tambah Voucher"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Voucher",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: "Kode Voucher",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Kode tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Nominal Diskon",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nominal harus diisi" : null,
              ),
              const SizedBox(height: 16),
              // Custom Date Picker Field
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Berlaku Sampai",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVoucher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isEditMode ? "Simpan Perubahan" : "Buat Voucher"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
