part of 'new_product_page_bloc.dart';

enum NewProductPageStatus { initial, ready, failure, saved, loading }

final class NewProductPageState extends Equatable {

  const NewProductPageState(
      {this.status = NewProductPageStatus.initial,
      this.productData,
      this.error});

  final ProductBody? productData;
  final NewProductPageStatus status;
  final InternalError? error;

  @override
  List<Object?> get props => [productData, status, error];

  @override
  String toString() {
    return '''NewProductPageState { status: $status, productData: ${productData?.description} }''';
  }

  NewProductPageState copyWith({
    ProductBody? productData,
    NewProductPageStatus? status,
    InternalError? error,
  }) {
    return NewProductPageState(
      status: status ?? this.status,
      productData: productData ?? this.productData,
      error: error ?? this.error,
    );
  }
}
