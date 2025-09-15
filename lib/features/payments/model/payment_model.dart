class PaymentModel {
  final int id;
  final int userId;
  final int orderId;
  final double amount;
  final String currency;
  final String method;
  final String status; // pending, completed, etc.
  final DateTime createdAt;
  final DateTime? updatedAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['user_id'],
      orderId: json['order_id'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      currency: json['currency'],
      method: json['method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_id': orderId,
      'amount': amount,
      'currency': currency,
      'method': method,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
