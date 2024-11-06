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

    on<NewProductPageOnSave>(_onSave);
  }

  Future<void> _onInit(
    NewProductPageInit event,
    Emitter<NewProductPageState> emit,
  ) async {
    emit(state.copyWith(
      productData: ProductBody(),
      status: NewProductPageStatus.ready
    ));

    print(state.productData);
  }

  Future<void> _onSave(
    NewProductPageOnSave event,
    Emitter<NewProductPageState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: NewProductPageStatus.loading,
      ));

      await _saveProduct(event.data);

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
    final data = ProductBody.toJson(product);

    final response = await httpClient.post(
      url,
      data: data,
    );

    if (response.statusCode == 201) {
      return;
    }
    throw InternalError.fromJson(response.data!);
  }
}
