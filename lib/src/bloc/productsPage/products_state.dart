part of 'products_bloc.dart';

enum ProductsPageStatus { initial, loading, success, failure }

final class ProductsState extends Equatable {

  const ProductsState({
    this.status = ProductsPageStatus.initial,
    this.products = const <Product>[],
    this.hasReachedMax = false,
  });

  final ProductsPageStatus status;
  final List<Product> products;
  final bool hasReachedMax;

  ProductsState copyWith({
    ProductsPageStatus? status,
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
