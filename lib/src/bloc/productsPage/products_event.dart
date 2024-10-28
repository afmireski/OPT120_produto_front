part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProductCreated extends ProductsEvent {}

final class ProductUpdated extends ProductsEvent {}

final class ProductDeleted extends ProductsEvent {}

final class ProductsFetched extends ProductsEvent {}

final class ProductDeletionRequested extends ProductsEvent {}
