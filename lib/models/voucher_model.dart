// voucher_model.dart

class Voucher {
  final String id;
  final String title;
  final String code;
  final double discountAmount;
  final DateTime validUntil;

  Voucher({
    required this.id,
    required this.title,
    required this.code,
    required this.discountAmount,
    required this.validUntil,
  });

  // Helper untuk format tanggal sederhana
  String get formattedDate {
    return "${validUntil.day}-${validUntil.month}-${validUntil.year}";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'discountAmount': discountAmount,
      'validUntil': validUntil.toIso8601String(),
    };
  }

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] as String,
      title: json['title'] as String,
      code: json['code'] as String,
      discountAmount: (json['discountAmount'] as num).toDouble(),
      validUntil: DateTime.parse(json['validUntil'] as String),
    );
  }
}