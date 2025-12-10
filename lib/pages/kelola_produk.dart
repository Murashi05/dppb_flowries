import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class KelolaProduk extends StatefulWidget {
  const KelolaProduk({super.key});

  @override
  State<KelolaProduk> createState() => _KelolaProdukState();
}

class _KelolaProdukState extends State<KelolaProduk> {
  final ProductService _productService = ProductService();

  final List<String> _availableImages = [
    'assets/images/flower1.png',
    'assets/images/flower2.png',
    'assets/images/flower3.png',
    'assets/images/flower4.png',
    'assets/images/flower5.png',
    'assets/images/flower6.png',
    'assets/images/flower7.png',
    'assets/images/flower8.png',
    'assets/images/flower9.png',
    'assets/images/flower10.png',
    'assets/images/flower11.png',
    'assets/images/flower12.png',
  ];

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    await _productService.initialize();
    setState(() {});
  }

  List<Product> get products => _productService.products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Produk'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddProductDialog();
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _productService,
        builder: (context, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.pink[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: product.gambar.startsWith('assets/')
                            ? Image.asset(
                                product.gambar,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      '🖼️',
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  product.gambar,
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.nama,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${product.harga.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.pink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stok: ${product.stok}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showEditProductDialog(product);
                        },
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Produk'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus produk ini?'),
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
                                    await _productService.deleteProduct(product.id);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Produk dihapus'),
                                      ),
                                    );
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog() {
    final namaController = TextEditingController();
    final deskripsiController = TextEditingController();
    final hargaController = TextEditingController();
    final stokController = TextEditingController();
    String selectedGambar = 'assets/images/flower1.png';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Preview Gambar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      selectedGambar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Pilih Gambar
                DropdownButton<String>(
                  value: selectedGambar,
                  isExpanded: true,
                  items: _availableImages.map((image) {
                    return DropdownMenuItem(
                      value: image,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 20);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(image.split('/').last)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGambar = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stokController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(),
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
                if (namaController.text.isNotEmpty &&
                    hargaController.text.isNotEmpty &&
                    deskripsiController.text.isNotEmpty &&
                    stokController.text.isNotEmpty) {
                  try {
                    await _productService.addProduct(
                      nama: namaController.text,
                      deskripsi: deskripsiController.text,
                      harga: double.parse(hargaController.text),
                      stok: int.parse(stokController.text),
                      gambar: selectedGambar,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Produk berhasil ditambahkan')),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    final namaController = TextEditingController(text: product.nama);
    final deskripsiController =
        TextEditingController(text: product.deskripsi);
    final hargaController =
        TextEditingController(text: product.harga.toString());
    final stokController = TextEditingController(text: product.stok.toString());
    String selectedGambar = product.gambar;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Preview Gambar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      selectedGambar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Pilih Gambar
                DropdownButton<String>(
                  value: selectedGambar,
                  isExpanded: true,
                  items: _availableImages.map((image) {
                    return DropdownMenuItem(
                      value: image,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 20);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(image.split('/').last),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGambar = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Produk',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stokController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(),
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
                try {
                  await _productService.updateProduct(
                    id: product.id,
                    nama: namaController.text,
                    deskripsi: deskripsiController.text,
                    harga: double.parse(hargaController.text),
                    stok: int.parse(stokController.text),
                    gambar: selectedGambar,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produk berhasil diupdate')),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
