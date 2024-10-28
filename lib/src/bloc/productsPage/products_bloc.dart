import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:opt120_produto_front/config/environment.dart';
import 'package:opt120_produto_front/src/models/products.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {

  final Dio httpClient;

  ProductsBloc({required this.httpClient}) : super(const ProductsState()) {
    on<ProductsFetched>(_onFetched);
  }

  Future<void> _onFetched(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final products = await _fetchProducts();

      emit(state.copyWith(
        status: ProductStatus.success,
        products: List.of(state.products)..addAll(products),
        hasReachedMax: false,
      ));
      
    } catch (e) {      
      print('Error: $e');
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<List<Product>> _fetchProducts() async {
    const url = '${Environment.apiUrl}/products';
    final response = await httpClient.get(url);

    if (response.statusCode == 200) {
      return response.data!.map<Product>((dynamic json) {
        return Product.fromJson(json);
      }).toList();
    }
    throw Exception('error fetching products');
  }
}