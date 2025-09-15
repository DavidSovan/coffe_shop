class OrderModel {
  final int id;
  final int userId;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderDetailModel> details;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.createdAt,
    required this.details,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: json['total_amount'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      details: (json['details'] as List)
          .map((detail) => OrderDetailModel.fromJson(detail))
          .toList(),
    );
  }
}

class OrderDetailModel {
  final int productId;
  final int quantity;
  final double unitPrice;
  final int id;
  final double subtotal;

  OrderDetailModel({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.id,
    required this.subtotal,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      productId: json['product_id'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      id: json['id'],
      subtotal: json['subtotal'].toDouble(),
    );
  }
}
