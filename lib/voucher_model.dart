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
}
