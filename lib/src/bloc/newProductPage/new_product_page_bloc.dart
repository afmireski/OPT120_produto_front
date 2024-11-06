import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opt120_produto_front/config/environment.dart';
import 'package:opt120_produto_front/src/models/internal_error.dart';
import 'package:opt120_produto_front/src/models/product_body.dart';

part 'new_product_page_event.dart';
part 'new_product_page_state.dart';

class NewProductPageBloc
    extends Bloc<NewProductPageEvent, NewProductPageState> {
  final Dio httpClient;

  NewProductPageBloc({required this.httpClient})
      : super(const NewProductPageState()) {
    on<NewProductPageInit>(_onInit);
  }

  Future<void> _onInit(
    NewProductPageInit event,
    Emitter<NewProductPageState> emit,
  ) async {
    emit(state.copyWith(
      status: NewProductPageStatus.initial,
      productData: ProductBody(),
    ));
  }

  Future<void> _onSave(
    NewProductPageOnSave event,
    Emitter<NewProductPageState> emit,
  ) async {
    try {
      await _saveProduct(state.productData!);

      emit(state.copyWith(
        status: NewProductPageStatus.saved,
      ));
    } on InternalError catch (e) {
      print('InternalError: $e');
      emit(state.copyWith(status: NewProductPageStatus.failure, error: e));
    } catch (e) {
      print('Exception: $e');
      emit(state.copyWith(
        status: NewProductPageStatus.failure,
        error: const InternalError(500, 'Erro ao salvar produto', 0),
      ));
    }
  }

  Future<void> _saveProduct(ProductBody product) async {
    const url = '${Environment.apiUrl}/products/new';

    final response = await httpClient.post(
      url,
      data: ProductBody.toJson(product),
    );

    if (response.statusCode == 201) {
      return;
    }
    throw InternalError.fromJson(response.data!);
  }
}
