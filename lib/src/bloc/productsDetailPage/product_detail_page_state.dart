part of 'product_detail_page_bloc.dart';

enum ProductDetailPageStatus { initial, loading, fetched, failure, deleteRequested, deleted, updatedRequested }

final class ProductDetailPageState extends Equatable {

  const ProductDetailPageState({
    this.status = ProductDetailPageStatus.initial,
    this.product,
  });

  final ProductDetailPageStatus status;
  final Product? product;

  ProductDetailPageState copyWith({
    ProductDetailPageStatus? status,
    Product? product,
  }) {
    return ProductDetailPageState(
      status: status ?? this.status,
      product: product ?? this.product,
    );
  }

  @override
  List<Object?> get props => [status, product];

  @override
  String toString() {
    return '''ProductsState { status: $status, product: ${product?.id.hashCode} }''';
  }
}