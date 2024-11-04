import 'package:equatable/equatable.dart';

final class Product extends Equatable {
  const Product({
    required this.id,
    required this.description,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final int id;
  final String description;
  final int price;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  @override
  List<Object?> get props => [
        id,
        description,
        price,
        stock,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      description: json['description'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deleted_at']) : null,
    );
  }

  static Map<String, dynamic> toJson(Product product) {
    return {
      'id': product.id,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': product.updatedAt.toIso8601String(),
      'deleted_at': product.deletedAt?.toIso8601String(),
    };
  }

  Product copyWith({
    int? id,
    String? description,
    int? price,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
