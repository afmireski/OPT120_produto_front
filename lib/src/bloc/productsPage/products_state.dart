part of 'products_bloc.dart';

enum ProductStatus { initial, loading, success, failure }

final class ProductsState extends Equatable {

  const ProductsState({
    this.status = ProductStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final ProductStatus status;
  final List<Product> products;
  final bool hasReachedMax;

  ProductsState copyWith({
    ProductStatus? status,
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, products, hasReachedMax];

  @override
  String toString() {
    return '''ProductsState { status: $status, hasReachedMax: $hasReachedMax, products: ${products.length} }''';
  }
}
