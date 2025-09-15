class ProductModel {
  final String? description;
  final bool? available;
  final String? name;
  final DateTime? createdAt;
  final int? id;
  final double? price;
  final String? imageUrl;
  final dynamic updatedAt;

  ProductModel({
    this.description,
    this.available,
    this.name,
    this.createdAt,
    this.id,
    this.price,
    this.imageUrl,
    this.updatedAt,
  });

  ProductModel copyWith({
    String? description,
    bool? available,
    String? name,
    DateTime? createdAt,
    int? id,
    double? price,
    String? imageUrl,
    dynamic updatedAt,
  }) {
    return ProductModel(
      description: description ?? this.description,
      available: available ?? this.available,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}