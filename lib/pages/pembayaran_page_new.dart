import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/transaction_service.dart';
import '../services/keranjang_service.dart';
import '../services/voucher_service.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  List<dynamic> items = [];
  double totalSebelumDiskon = 0;
  String? selectedVoucherId;
  double diskonNominal = 0;
  String? selectedMetodePembayaran;
  final TextEditingController alamatController = TextEditingController();
  final VoucherService _voucherService = VoucherService();
  double ongkosKirim = 0;

  @override
  void initState() {
    super.initState();
    _initializeVouchers();
    
    // Load data immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadArgumentsData();
    });
  }

  Future<void> _initializeVouchers() async {
    await _voucherService.initialize();
    setState(() {});
  }

  void _loadArgumentsData() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    
    if (arguments == null) {
      print('❌ Tidak ada arguments');
      return;
    }
    
    print('✅ Menerima data dari halaman sebelumnya');
    print('Arguments keys: ${arguments.keys}');
    print('Arguments: $arguments');
    
    // CART MODE (dari KeranjangPage) - prioritas utama
    if (arguments['items'] != null && arguments['items'] is List) {
      print('🛒 MODE: Keranjang');
      final itemsList = arguments['items'] as List;
      setState(() {
        items = List.from(itemsList);
        totalSebelumDiskon = _calculateTotalFromItems(items);
        print('✅ Keranjang loaded: ${items.length} item(s), Total: Rp $totalSebelumDiskon');
      });
    } 
    // SINGLE PRODUCT MODE (dari DetailProdukPage)
    else if (arguments['type'] == 'single' && arguments['product'] != null) {
      print('📦 MODE: Single Product');
      final product = arguments['product'] as Map<String, dynamic>;
      final quantity = (arguments['quantity'] ?? 1) as int;
      final totalFromArg = arguments['total'];
      
      // Convert total ke double, bisa dari int atau double
      double calculatedTotal = totalFromArg is double 
          ? totalFromArg 
          : (totalFromArg is int ? totalFromArg.toDouble() : (product["harga"] * quantity).toDouble());
      
      setState(() {
        items = [
          {
            'productId': product["id"],
            'name': product["nama"],
            'price': product["harga"].toDouble(),
            'image': product["gambar"],
            'quantity': quantity,
            'isSelected': true,
          }
        ];
        
        totalSebelumDiskon = calculatedTotal;
        print('✅ Single product loaded: Total: Rp $totalSebelumDiskon');
      });
    } else {
      print('❌ Mode tidak dikenali atau data tidak lengkap');
      print('Arguments type: ${arguments['type']}');
      print('Arguments items: ${arguments['items']}');
      print('Arguments product: ${arguments['product']}');
    }
  }

  double _calculateTotalFromItems(List<dynamic> itemList) {
    double total = 0;
    for (var item in itemList) {
      try {
        int quantity = 0;
        int price = 0;
        bool isSelected = true;
        
        // Handle KeranjangItem object (dari keranjang)
        if (item.runtimeType.toString().contains('KeranjangItem')) {
          quantity = item.quantity;
          price = item.price;
          isSelected = item.isSelected ?? true;
        } 
        // Handle Map object (dari detail produk atau lainnya)
        else if (item is Map) {
          quantity = item['quantity'] ?? 0;
          price = item['price'] ?? 0;
          isSelected = item['isSelected'] ?? true;
        }
        
        if (isSelected && quantity > 0 && price > 0) {
          total += (quantity * price).toDouble();
          print('✅ Item: quantity=$quantity, price=$price, subtotal=${quantity * price}');
        }
      } catch (e) {
        print('❌ Error calculating item: $e');
      }
    }
    print('📊 Total calculated: Rp $total');
    return total;
  }

  void _applyVoucher(String voucherId) {
    final voucher = _voucherService.getVoucherById(voucherId);

    if (voucher == null || voucher.validUntil.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher tidak valid atau sudah kadaluarsa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Gunakan discountAmount langsung dari voucher
    final discount = voucher.discountAmount;
    setState(() {
      selectedVoucherId = voucherId;
      diskonNominal = discount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voucher ${voucher.code} berhasil diterapkan! Hemat Rp ${discount.toStringAsFixed(0)}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double get totalSetelahDiskon => totalSebelumDiskon - diskonNominal + ongkosKirim;

  void _processPayment() {
    if (selectedMetodePembayaran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran')),
      );
      return;
    }
    if (alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat pengiriman tidak boleh kosong')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Produk: Rp ${totalSebelumDiskon.toStringAsFixed(0)}'),
            if (diskonNominal > 0)
              Text('Diskon: -Rp ${diskonNominal.toStringAsFixed(0)}'),
            Text('Ongkos Kirim: Rp ${ongkosKirim.toStringAsFixed(0)}'),
            const Divider(),
            Text(
              'Total Pembayaran: Rp ${totalSetelahDiskon.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Metode: $selectedMetodePembayaran'),
            Text('Alamat: ${alamatController.text}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completePayment();
            },
            child: const Text('Bayar'),
          ),
        ],
      ),
    );
  }

  void _completePayment() {
    try {
      // Buat transaksi baru
      final transactionService = TransactionService();
      final keranjangService = KeranjangService();
      
      // Konversi items ke CartItem list
      List<CartItem> cartItems = [];
      for (var item in items) {
        String name = '';
        String gambar = '';
        double price = 0.0;
        int qty = 0;
        
        if (item is Map) {
          name = item['name'] ?? '';
          gambar = item['image'] ?? 'assets/images/flower1.png';
          price = (item['price'] as num).toDouble();
          qty = item['quantity'] as int;
        } else if (item.runtimeType.toString().contains('KeranjangItem')) {
          name = item.name;
          gambar = item.image;
          price = (item.price as num).toDouble();
          qty = item.quantity;
        }
        
        cartItems.add(CartItem(
          id: '${cartItems.length + 1}',
          productId: item is Map ? item['productId'] ?? '' : item.productId,
          productNama: name,
          productHarga: price,
          productGambar: gambar,
          quantity: qty,
        ));
      }
      
      // Generate ID transaksi unik
      // Simpan transaksi ke service dengan named parameters
      transactionService.addTransaction(
        userId: '1', // TODO: Sesuaikan dengan user yang login
        items: cartItems,
        totalSebelumDiskon: totalSebelumDiskon,
        diskonNominal: diskonNominal,
        totalSetelahDiskon: (totalSebelumDiskon - diskonNominal + ongkosKirim),
        voucherId: selectedVoucherId ?? '',
        voucherKode: selectedVoucherId != null 
            ? _voucherService.getVoucherById(selectedVoucherId!)?.code ?? ''
            : null,
        status: 'diproses',
        tanggalPemesanan: DateTime.now(),
        metodePembayaran: selectedMetodePembayaran ?? 'Tidak dipilih',
        alamatPengiriman: alamatController.text,
      );
      print('✅ Transaksi disimpan');
      
      // Clear keranjang
      keranjangService.clearKeranjang();
      print('✅ Keranjang dikosongkan');
      
    } catch (e) {
      print('❌ Error menyimpan transaksi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    // Tampilkan dialog sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran Berhasil'),
        content: const Text('Pesanan Anda sedang diproses. Anda dapat melihat riwayat transaksi di menu Riwayat.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/riwayat');
            },
            child: const Text('Lihat Riwayat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== RINCIAN PESANAN ==========
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rincian Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // DAFTAR PRODUK
                  if (items.isNotEmpty)
                    ...items.map((item) {
                      final name = item is Map ? item['name'] : item.name;
                      final quantity = item is Map ? item['quantity'] : item.quantity;
                      final price = item is Map ? item['price'] : item.price;
                      final subtotal = (quantity * price).toDouble();
                      
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                'x$quantity',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '   @ Rp ${price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rp ${subtotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                  
                  const Divider(),
                  
                  // RINGKASAN HARGA
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal Produk:'),
                      Text(
                        'Rp ${totalSebelumDiskon.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  if (diskonNominal > 0) ...[
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Diskon Voucher:'),
                        Text(
                          '-Rp ${diskonNominal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ongkos Kirim:'),
                      Text(
                        'Rp ${ongkosKirim.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Pembayaran:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${totalSetelahDiskon.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ========== VOUCHER ==========
            const Text(
              'Gunakan Voucher',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: _voucherService,
              builder: (context, _) {
                final validVouchers = _voucherService.getValidVouchers();
                
                if (validVouchers.isEmpty)
                  return const Text('Tidak ada voucher tersedia');
                
                return Column(
                  children: validVouchers.map((voucher) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedVoucherId == voucher.id
                                ? Colors.pink
                                : Colors.grey[300]!,
                            width: selectedVoucherId == voucher.id ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: selectedVoucherId == voucher.id
                              ? Colors.pink.withOpacity(0.05)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    voucher.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    voucher.title,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hemat: Rp ${voucher.discountAmount.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedVoucherId == voucher.id
                                    ? Colors.pink
                                    : Colors.grey[300],
                              ),
                              onPressed: () {
                                _applyVoucher(voucher.id);
                              },
                              child: Text(
                                selectedVoucherId == voucher.id
                                    ? 'Gunakan'
                                    : 'Pilih',
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                );
              },
            ),

            const SizedBox(height: 25),

            // ========== ONGKOS KIRIM ==========
            const Text(
              'Pilih Ongkos Kirim',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                {'name': 'Reguler (3-5 hari)', 'price': 15000},
                {'name': 'Express (1-2 hari)', 'price': 30000},
                {'name': 'Gratis Ongkir', 'price': 0},
              ].map((shipping) {
                final name = shipping['name'] as String;
                final price = shipping['price'] as int;
                return RadioListTile(
                  title: Text(name),
                  subtitle: Text(price > 0 
                      ? 'Rp ${price}' 
                      : 'Gratis'),
                  value: price.toDouble(),
                  groupValue: ongkosKirim,
                  onChanged: (value) {
                    setState(() {
                      ongkosKirim = (value ?? 0).toDouble();
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            // ========== ALAMAT ==========
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: alamatController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat pengiriman lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),

            const SizedBox(height: 25),

            // ========== METODE PEMBAYARAN ==========
            const Text(
              'Metode Pembayaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ...['Transfer Bank', 'E-Wallet', 'COD']
                    .map((method) => RadioListTile(
                          title: Text(method),
                          value: method,
                          groupValue: selectedMetodePembayaran,
                          onChanged: (value) {
                            setState(() {
                              selectedMetodePembayaran = value;
                            });
                          },
                        )),
              ],
            ),

            const SizedBox(height: 25),

            // ========== TOMBOL BAYAR ==========
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: _processPayment,
                child: const Text(
                  'Lakukan Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    alamatController.dispose();
    super.dispose();
  }
}