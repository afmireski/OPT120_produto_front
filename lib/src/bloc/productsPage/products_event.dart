part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductsInit extends ProductsEvent {}

final class ProductsFetched extends ProductsEvent {}
