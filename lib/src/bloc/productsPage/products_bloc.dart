import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:opt120_produto_front/config/environment.dart';
import 'package:opt120_produto_front/src/models/internal_error.dart';
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
    try {
      final products = await _fetchProducts();

      if (products.isEmpty) {
        emit(
          state.copyWith(status: ProductsPageStatus.empty, products: []),
        );
        return;
      }

      emit(state.copyWith(
        status: ProductsPageStatus.success,
        products: List.empty(growable: true)..addAll(products),
      ));
    } on InternalError catch (e) {
      print('InternalError: $e');
      emit(state.copyWith(status: ProductsPageStatus.failure, error: e));
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(status: ProductsPageStatus.failure));
    }
  }

  Future<List<Product>> _fetchProducts() async {
    const url = '${Environment.apiUrl}/products';

    final response = await httpClient.get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status! < 600,
      ),
    );

    if (response.statusCode == 200) {
      return response.data!.map<Product>((json) {
        return Product.fromJson(json);
      }).toList();
    } else if (response.statusCode == 204) {
      return [];
    }
    throw InternalError.fromJson(response.data!);
  }
}
