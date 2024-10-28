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

  static fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      description: json['description'] as String,
      price: json['price'] as int,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}