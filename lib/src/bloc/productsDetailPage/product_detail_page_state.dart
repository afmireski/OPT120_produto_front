part of 'product_detail_page_bloc.dart';

enum ProductDetailPageStatus { initial, loading, fetched, failure, deleteRequested, deleted, updatedRequested }

final class ProductDetailPageState extends Equatable {

  const ProductDetailPageState({
    this.status = ProductDetailPageStatus.initial,
    this.product,
    this.error,
  });

  final ProductDetailPageStatus status;
  final Product? product;
  final InternalError? error;

  ProductDetailPageState copyWith({
    ProductDetailPageStatus? status,
    Product? product,
    InternalError? error,
  }) {
    return ProductDetailPageState(
      status: status ?? this.status,
      product: product ?? this.product,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, product, error];

  @override
  String toString() {
    return '''ProductsState { status: $status, product: ${product?.id.hashCode} }''';
  }
}