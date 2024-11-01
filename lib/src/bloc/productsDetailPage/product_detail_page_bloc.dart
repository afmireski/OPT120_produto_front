import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opt120_produto_front/config/environment.dart';
import 'package:opt120_produto_front/src/models/products.dart';

part 'product_detail_page_event.dart';
part 'product_detail_page_state.dart';

class ProductsBloc
    extends Bloc<ProductDetailPageEvent, ProductDetailPageState> {
  final int productId;
  final Dio httpClient;

  ProductsBloc({required this.productId, required this.httpClient})
      : super(const ProductDetailPageState()) {
    on<ProductDetailPageFetch>(_onFetched);

    on<ProductDetailPageDeleteRequested>(_onDelete);
  }

  Future<void> _onFetched(
    ProductDetailPageFetch event,
    Emitter<ProductDetailPageState> emit,
  ) async {
    try {
      final product = await _fetchProduct();

      emit(state.copyWith(
        status: ProductDetailPageStatus.fetched,
        product: product,
      ));
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(status: ProductDetailPageStatus.failure));
    }
  }

  Future<Product> _fetchProduct() async {
    final url = '${Environment.apiUrl}/product/${this.productId}';

    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      return Product.fromJson(response.data!);
    }
    throw Exception('error fetching product');
  }

  Future<void> _onDelete(
    ProductDetailPageDeleteRequested event,
    Emitter<ProductDetailPageState> emit,
  ) async {
    emit(state.copyWith(
      status: ProductDetailPageStatus.deleteRequested,
    ));

    final url = '${Environment.apiUrl}/product/${this.productId}/remove';

    final response = await httpClient.delete(url);

    if (response.statusCode == 204) {
      emit(state.copyWith(
        status: ProductDetailPageStatus.deleted,
      ));
      return;
    }
    throw Exception('error fetching product');
  }
}
