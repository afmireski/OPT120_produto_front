import 'package:equatable/equatable.dart';

final class ProductBody extends Equatable {
  ProductBody({
    this.description = '',
    this.price = 0,
    this.stock = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  final String description;
  final int price;
  final int stock;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        description,
        price,
        stock,
        createdAt,
      ];

  static Map<String, dynamic> toJson(ProductBody product) {
    return {
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'created_at': product.createdAt.toIso8601String()
    };
  }

  ProductBody copyWith({
    String? description,
    int? price,
    int? stock,
    DateTime? createdAt,
  }) {
    return ProductBody(
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
