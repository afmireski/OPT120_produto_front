part of 'new_product_page_bloc.dart';

sealed class NewProductPageEvent extends Equatable {
   @override
  List<Object?> get props => [];
}

final class NewProductPageInit extends NewProductPageEvent {}

final class NewProductPageOnSave extends NewProductPageEvent {}

