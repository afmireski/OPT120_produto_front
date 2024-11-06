part of 'products_bloc.dart';

enum ProductsPageStatus { initial, loading, empty, success, failure }

final class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsPageStatus.initial,
    this.products = const <Product>[],
    this.error,
  });

  final ProductsPageStatus status;
  final List<Product> products;
  final InternalError? error;

  ProductsState copyWith({
    ProductsPageStatus? status,
    List<Product>? products,
    InternalError? error,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, products, error];

  @override
  String toString() {
    return '''ProductsState { status: $status, products: ${products.length} }''';
  }
}
