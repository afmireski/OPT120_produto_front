part of 'product_detail_page_bloc.dart';

sealed class ProductDetailPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductDetailPageInit extends ProductDetailPageEvent {}

final class ProductDetailPageFetch extends ProductDetailPageEvent {}

final class ProductDetailPageEditRequested extends ProductDetailPageEvent {}

final class ProductDetailPageUpdateRequested extends ProductDetailPageEvent {
  ProductDetailPageUpdateRequested(this.newData);

  final Product newData;
}

final class ProductDetailPageDeleteRequested extends ProductDetailPageEvent {}
