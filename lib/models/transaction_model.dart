import 'cart_model.dart';

class Transaction {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalSebelomDiskon;
  final double diskonNominal;
  final double totalSetelahDiskon;
  final String voucherId;
  final String? voucherKode;
  final String status; // 'menunggu', 'diproses', 'selesai', 'dibatalkan'
  final DateTime tanggalPemesanan;
  final DateTime? tanggalSelesai;
  final String metodePembayaran;
  final String alamatPengiriman;

  Transaction({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalSebelomDiskon,
    required this.diskonNominal,
    required this.totalSetelahDiskon,
    required this.voucherId,
    this.voucherKode,
    required this.status,
    required this.tanggalPemesanan,
    this.tanggalSelesai,
    required this.metodePembayaran,
    required this.alamatPengiriman,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalSebelomDiskon': totalSebelomDiskon,
      'diskonNominal': diskonNominal,
      'totalSetelahDiskon': totalSetelahDiskon,
      'voucherId': voucherId,
      'voucherKode': voucherKode,
      'status': status,
      'tanggalPemesanan': tanggalPemesanan.toIso8601String(),
      'tanggalSelesai': tanggalSelesai?.toIso8601String(),
      'metodePembayaran': metodePembayaran,
      'alamatPengiriman': alamatPengiriman,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      items: List<CartItem>.from(
          (json['items'] as List).map((item) => CartItem.fromJson(item))),
      totalSebelomDiskon: json['totalSebelomDiskon'].toDouble(),
      diskonNominal: json['diskonNominal'].toDouble(),
      totalSetelahDiskon: json['totalSetelahDiskon'].toDouble(),
      voucherId: json['voucherId'],
      voucherKode: json['voucherKode'],
      status: json['status'],
      tanggalPemesanan: DateTime.parse(json['tanggalPemesanan']),
      tanggalSelesai: json['tanggalSelesai'] != null
          ? DateTime.parse(json['tanggalSelesai'])
          : null,
      metodePembayaran: json['metodePembayaran'],
      alamatPengiriman: json['alamatPengiriman'],
    );
  }
}
