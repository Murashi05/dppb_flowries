import 'package:flutter/material.dart';
import '../services/review_service.dart';

class DaftarUlasanPage extends StatefulWidget {
  const DaftarUlasanPage({super.key});

  @override
  State<DaftarUlasanPage> createState() => _DaftarUlasanPageState();
}

class _DaftarUlasanPageState extends State<DaftarUlasanPage> {
  final ReviewService _reviewService = ReviewService();

  @override
  void initState() {
    super.initState();
    _initializeReviews();
  }

  Future<void> _initializeReviews() async {
    await _reviewService.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ulasan Saya'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _reviewService,
        builder: (context, _) {
          final reviews = _reviewService.reviews;
          
          return reviews.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 60,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Belum ada ulasan',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/riwayat');
                        },
                        child: const Text('Buat Ulasan'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
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
                          // Product Info
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    review.userName[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          // Rating
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                size: 18,
                                color: i < review.rating
                                    ? Colors.amber
                                    : Colors.grey[300],
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Comment
                          Text(
                            review.isiUlasan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Date
                          Text(
                            review.tanggalUlasan.toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Actions
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Edit ulasan sedang dalam pengembangan'),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Hapus Ulasan'),
                                        content: const Text(
                                            'Apakah Anda yakin ingin menghapus ulasan ini?'),
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
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // Remove review dari service dan rebuild
                                              _reviewService.reviews
                                                  .removeAt(index);
                                              setState(() {});
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text('Ulasan dihapus'),
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
    );
  }
}
