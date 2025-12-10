import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final int rating;
  final String isiUlasan;
  final DateTime tanggalUlasan;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.isiUlasan,
    required this.tanggalUlasan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'isiUlasan': isiUlasan,
      'tanggalUlasan': tanggalUlasan.toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      userId: json['userId'],
      userName: json['userName'],
      rating: json['rating'],
      isiUlasan: json['isiUlasan'],
      tanggalUlasan: DateTime.parse(json['tanggalUlasan']),
    );
  }
}

class ReviewService extends ChangeNotifier {
  static final ReviewService _instance = ReviewService._internal();

  factory ReviewService() {
    return _instance;
  }

  ReviewService._internal();

  List<Review> _reviews = [];
  final String _storageKey = 'reviews_data';

  List<Review> get reviews => List.from(_reviews);

  // Initialize from storage
  Future<void> initialize() async {
    await _loadFromStorage();
    
    // Jika pertama kali (storage kosong), isi dengan default reviews
    if (_reviews.isEmpty) {
      print('📌 Storage kosong, menambahkan default reviews...');
      await _addDefaultReviews();
    } else {
      print('📌 Loaded ${_reviews.length} reviews dari storage');
    }
    
    // Notify listeners saat initialize selesai
    notifyListeners();
  }

  // Reset dan load default reviews (untuk development/testing)
  Future<void> resetAndLoadDefaults() async {
    _reviews.clear();
    await _addDefaultReviews();
  }

  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,
    required int rating,
    required String isiUlasan,
    required DateTime tanggalUlasan,
  }) async {
    final newReview = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: productId,
      userId: userId,
      userName: userName,
      rating: rating,
      isiUlasan: isiUlasan,
      tanggalUlasan: tanggalUlasan,
    );
    _reviews.add(newReview);
    await _saveToStorage();
    notifyListeners();
    print('✅ Review ditambahkan: $userName - Rating $rating');
  }

  Future<void> deleteReview(String id) async {
    _reviews.removeWhere((review) => review.id == id);
    await _saveToStorage();
    notifyListeners();
    print('✅ Review dihapus dengan id: $id');
  }

  // Get reviews by product ID
  List<Review> getReviewsByProductId(String productId) {
    return _reviews
        .where((review) => review.productId == productId)
        .toList();
  }

  // Get reviews by user ID
  List<Review> getReviewsByUserId(String userId) {
    return _reviews
        .where((review) => review.userId == userId)
        .toList();
  }

  // Get all reviews
  List<Review> getAllReviews() {
    return List.from(_reviews);
  }

  // Get average rating for product
  double getAverageRating(String productId) {
    final productReviews = getReviewsByProductId(productId);
    if (productReviews.isEmpty) return 0.0;
    
    final totalRating = productReviews.fold<int>(0, (sum, review) => sum + review.rating);
    return totalRating / productReviews.length;
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _reviews.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
    print('✅ Saved ${_reviews.length} reviews to SharedPreferences');
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];
    print('📌 Found $jsonList in storage');
    _reviews = jsonList
        .map((json) => Review.fromJson(jsonDecode(json)))
        .toList();
    print('📌 Loaded ${_reviews.length} reviews from storage');
  }

  Future<void> _addDefaultReviews() async {
    // Default review 1
    _reviews.add(
      Review(
        id: 'REVIEW001',
        productId: '1',
        userId: 'USER001',
        userName: 'Budi Santoso',
        rating: 5,
        isiUlasan: 'Bunga mawar merahnya sangat segar dan cantik! Packing rapi sekali. Recommended!',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 5)),
      ),
    );

    // Default review 2
    _reviews.add(
      Review(
        id: 'REVIEW002',
        productId: '1',
        userId: 'USER002',
        userName: 'Siti Nurhaliza',
        rating: 4,
        isiUlasan: 'Bagus, tapi waktu pengiriman agak lama. Flowers-nya masih bagus kok.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 3)),
      ),
    );

    // Default review 3
    _reviews.add(
      Review(
        id: 'REVIEW003',
        productId: '2',
        userId: 'USER003',
        userName: 'Ahmad Wijaya',
        rating: 5,
        isiUlasan: 'Tulip kuning yang cantik! Pelayanan customer service sangat responsif.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 2)),
      ),
    );

    // Default review 4
    _reviews.add(
      Review(
        id: 'REVIEW004',
        productId: '3',
        userId: 'USER004',
        userName: 'Rina Wijaya',
        rating: 3,
        isiUlasan: 'Lumayan bagus, tapi beberapa kelopak sudah mulai rontok saat diterima.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 4)),
      ),
    );

    // Default review 5
    _reviews.add(
      Review(
        id: 'REVIEW005',
        productId: '1',
        userId: 'USER005',
        userName: 'Dani Kusuma',
        rating: 5,
        isiUlasan: 'Sangat puas! Warna merah cerah, aroma harum, dan tiba tepat waktu.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );

    // Default review 6
    _reviews.add(
      Review(
        id: 'REVIEW006',
        productId: '2',
        userId: 'USER006',
        userName: 'Lina Setiawan',
        rating: 2,
        isiUlasan: 'Sayang sekali, tulipnya terlihat sudah layu saat tiba. Kecewa dengan kondisinya.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 6)),
      ),
    );

    // Default review 7
    _reviews.add(
      Review(
        id: 'REVIEW007',
        productId: '3',
        userId: 'USER007',
        userName: 'Roni Hartono',
        rating: 4,
        isiUlasan: 'Bunga lili putih sangat harum dan tahan lama. Sangat worth it!',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 7)),
      ),
    );

    // Default review 8
    _reviews.add(
      Review(
        id: 'REVIEW008',
        productId: '1',
        userId: 'USER008',
        userName: 'Maya Handoko',
        rating: 1,
        isiUlasan: 'Sangat mengecewakan. Bunga rusak dan tidak sesuai gambar. Minta refund tapi ditolak.',
        tanggalUlasan: DateTime.now().subtract(const Duration(days: 8)),
      ),
    );

    await _saveToStorage();
    notifyListeners();
    print('✅ Default reviews ditambahkan');
  }
}
