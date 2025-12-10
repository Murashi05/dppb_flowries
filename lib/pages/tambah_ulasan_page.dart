import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/review_service.dart';

class TambahUlasanPage extends StatefulWidget {
  final Transaction transaction;

  const TambahUlasanPage({super.key, required this.transaction});

  @override
  State<TambahUlasanPage> createState() => _TambahUlasanPageState();
}

class _TambahUlasanPageState extends State<TambahUlasanPage> {
  late Map<String, dynamic> reviewData;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    reviewData = {
      for (var item in widget.transaction.items)
        item.productId: {
          'rating': 5,
          'komentar': '',
        }
    };
  }

  void _submitReviews() async {
    bool isValid = true;
    for (var item in widget.transaction.items) {
      final data = reviewData[item.productId];
      if (data['komentar'].isEmpty) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua ulasan harus diisi')),
      );
      return;
    }

    // Simpan semua ulasan ke ReviewService
    final reviewService = ReviewService();
    await reviewService.initialize();
    for (var item in widget.transaction.items) {
      final data = reviewData[item.productId];
      await reviewService.addReview(
        productId: item.productId,
        userId: '1', // TODO: Sesuaikan dengan user yang login
        userName: 'Pembeli', // TODO: Sesuaikan dengan nama user
        rating: data['rating'],
        isiUlasan: data['komentar'],
        tanggalUlasan: DateTime.now(),
      );
      print('✅ Review disimpan untuk produk: ${item.productNama}');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ulasan Berhasil Disimpan'),
        content: const Text('Terima kasih atas ulasan Anda!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/riwayat');
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.transaction.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ulasan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: List.generate(
                products.length,
                (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: index <= _currentIndex ? Colors.pink : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Review Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              products[_currentIndex].productGambar,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[_currentIndex].productNama,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Qty: ${products[_currentIndex].quantity}',
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
                  ),

                  const SizedBox(height: 25),

                  // Rating
                  const Text(
                    'Berapa rating yang Anda berikan?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            reviewData[products[_currentIndex].productId]['rating'] =
                                index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 40,
                          color: index <
                                  reviewData[products[_currentIndex]
                                      .productId]['rating']
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Comment
                  const Text(
                    'Berikan Komentar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() {
                        reviewData[products[_currentIndex].productId]
                            ['komentar'] = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tulis pengalaman Anda dengan produk ini...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Navigation Buttons
                  Row(
                    children: [
                      if (_currentIndex > 0)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _currentIndex--;
                              });
                            },
                            child: const Text('Sebelumnya'),
                          ),
                        ),
                      if (_currentIndex > 0) const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                          onPressed: () {
                            if (_currentIndex < products.length - 1) {
                              setState(() {
                                _currentIndex++;
                              });
                            } else {
                              _submitReviews();
                            }
                          },
                          child: Text(
                            _currentIndex == products.length - 1
                                ? 'Simpan Ulasan'
                                : 'Selanjutnya',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
