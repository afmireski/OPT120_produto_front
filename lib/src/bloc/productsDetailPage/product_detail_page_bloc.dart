import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opt120_produto_front/config/environment.dart';
import 'package:opt120_produto_front/src/models/internal_error.dart';
import 'package:opt120_produto_front/src/models/products.dart';

part 'product_detail_page_event.dart';
part 'product_detail_page_state.dart';

class ProductDetailPageBloc
    extends Bloc<ProductDetailPageEvent, ProductDetailPageState> {
  final int productId;
  final Dio httpClient;

  ProductDetailPageBloc({required this.productId, required this.httpClient})
      : super(const ProductDetailPageState()) {
    on<ProductDetailPageFetch>(_onFetched);

    on<ProductDetailPageDeleteRequested>(_onDelete);

    on<ProductDetailPageEditRequested>(_onEditRequested);

    on<ProductDetailPageUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onFetched(
    ProductDetailPageFetch event,
    Emitter<ProductDetailPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: ProductDetailPageStatus.loading,
      ));

      final product = await _fetchProduct();

      emit(state.copyWith(
        status: ProductDetailPageStatus.fetched,
        product: product,
      ));
    } on InternalError catch (e) {
      print('InternalError: $e');
      emit(state.copyWith(status: ProductDetailPageStatus.failure, error: e));
    } catch (e) {
      print('Exception: $e');
      emit(state.copyWith(
        status: ProductDetailPageStatus.failure,
        error: const InternalError(500, 'Erro ao buscar produto', 0),
      ));
    }
  }

  Future<Product> _fetchProduct() async {
    final url = '${Environment.apiUrl}/products/${this.productId}';

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
      return Product.fromJson(response.data!);
    }
    throw InternalError.fromJson(response.data!);
  }

  Future<void> _onDelete(
    ProductDetailPageDeleteRequested event,
    Emitter<ProductDetailPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: ProductDetailPageStatus.deleteRequested,
      ));

      await _deleteProduct();

      emit(state.copyWith(
        status: ProductDetailPageStatus.deleted,
      ));
    } on InternalError catch (e) {
      print('InternalError: $e');
      emit(state.copyWith(status: ProductDetailPageStatus.failure, error: e));
    } catch (e) {
      print('Exception: $e');
      emit(state.copyWith(
        status: ProductDetailPageStatus.failure,
        error: const InternalError(500, 'Erro ao deletar produto', 0),
      ));
    }
  }

  Future<void> _deleteProduct() async {
    final url = '${Environment.apiUrl}/products/${this.productId}/remove';

    final response = await httpClient.delete(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status! < 600,
      ),
    );

    if (response.statusCode == 204) {
      return;
    }
    throw InternalError.fromJson(response.data!);
  }

  void _onEditRequested(
    ProductDetailPageEditRequested event,
    Emitter<ProductDetailPageState> emit,
  ) {
    emit(state.copyWith(
      status: ProductDetailPageStatus.updatedRequested,
      tmpProduct: state.product,
    ));
  }

  Future<void> _onUpdateRequested(
    ProductDetailPageUpdateRequested event,
    Emitter<ProductDetailPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: ProductDetailPageStatus.loading,
        tmpProduct: event.newData,
      ));

      await _updateProduct(event.newData);

      emit(state.copyWith(
        status: ProductDetailPageStatus.updated,
      ));
    } on InternalError catch (e) {
      print('InternalError: $e');
      emit(state.copyWith(status: ProductDetailPageStatus.failure, error: e));
    } catch (e) {
      print('Exception: $e');
      emit(state.copyWith(
        status: ProductDetailPageStatus.failure,
        error: const InternalError(500, 'Erro ao atualizar produto', 0),
      ));
    }
  }

  Future<void> _updateProduct(Product productData) async {
    final url = '${Environment.apiUrl}/products/${this.productId}/update';

    var data = Product.toJson(productData);
    data.remove('id');
    data.remove('updated_at');
    data.remove('deleted_at');

    final response = await httpClient.patch(
      url,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => status! < 600,
      ),
    );

    if (response.statusCode == 200) {
      return;
    }
    throw InternalError.fromJson(response.data!);
  }
}
