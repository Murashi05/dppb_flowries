import 'package:flutter/material.dart';
import '../services/review_service.dart';

class LihatUlasan extends StatefulWidget {
  const LihatUlasan({super.key});

  @override
  State<LihatUlasan> createState() => _LihatUlasanState();
}

class _LihatUlasanState extends State<LihatUlasan> {
  late ReviewService _reviewService;
  String selectedSort = 'terbaru';
  String selectedRating = 'semua';

  @override
  void initState() {
    super.initState();
    _reviewService = ReviewService();
    _initializeReviews();
  }

  Future<void> _initializeReviews() async {
    // Uncomment line dibawah jika ingin reset data dummy
    await _reviewService.resetAndLoadDefaults();
    // await _reviewService.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  List<Map<String, dynamic>> get filteredReviews {
    var filtered = _reviewService.reviews.map((review) {
      return {
        'userId': review.userId,
        'userName': review.userName,
        'rating': review.rating,
        'isiUlasan': review.isiUlasan,
        'tanggalUlasan': review.tanggalUlasan,
        'productId': review.productId,
      };
    }).toList();

    if (selectedRating != 'semua') {
      final rating = int.parse(selectedRating);
      filtered = filtered.where((r) => r['rating'] == rating).toList();
    }

    if (selectedSort == 'tertinggi') {
      filtered.sort((a, b) => (b['rating'] as int).compareTo(a['rating'] as int));
    } else if (selectedSort == 'terendah') {
      filtered.sort((a, b) => (a['rating'] as int).compareTo(b['rating'] as int));
    } else {
      filtered.sort((a, b) => (b['tanggalUlasan'] as DateTime).compareTo(a['tanggalUlasan'] as DateTime));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lihat Ulasan'),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _reviewService,
        builder: (context, _) {
          return Column(
            children: [
              // Filter Section
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Urutkan:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedSort,
                      items: const [
                        DropdownMenuItem(value: 'terbaru', child: Text('Terbaru')),
                        DropdownMenuItem(
                            value: 'tertinggi', child: Text('Rating Tertinggi')),
                        DropdownMenuItem(
                            value: 'terendah', child: Text('Rating Terendah')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedSort = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Filter Rating:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['semua', '5', '4', '3', '2', '1']
                            .map((rating) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(rating == 'semua'
                                        ? 'Semua'
                                        : '⭐ $rating'),
                                    selected: selectedRating == rating,
                                    onSelected: (selected) {
                                      setState(() {
                                        selectedRating = rating;
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Reviews List
              Expanded(
                child: filteredReviews.isEmpty
                    ? const Center(
                        child: Text('Belum ada ulasan'),
                      )
                    : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
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
                            // Header
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['userName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.amber.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star,
                                          size: 14,
                                          color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${review['rating']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Comment
                            Text(
                              review['isiUlasan'],
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Date
                            Text(
                              review['tanggalUlasan']
                                  .toString()
                                  .split(' ')[0],
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Actions - Only View
                            OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      review['userName'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Rating
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              Icons.star,
                                              size: 18,
                                              color: i <
                                                      review['rating']
                                                  ? Colors.amber
                                                  : Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Review content
                                        Text(
                                          review['isiUlasan'],
                                          style: const TextStyle(
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Date
                                        Text(
                                          review['tanggalUlasan']
                                              .toString()
                                              .split(' ')[0],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Tutup'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.visibility, size: 16),
                              label: const Text('Lihat Lengkap'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ),
            ],
          );
        },
      ),
    );
  }
}
