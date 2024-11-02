import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opt120_produto_front/src/bloc/productsDetailPage/product_detail_page_bloc.dart';
import 'package:opt120_produto_front/src/bloc/productsPage/products_bloc.dart';
import 'package:opt120_produto_front/src/page/product_detail_page.dart';
import 'package:opt120_produto_front/src/page/products_page.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  // GoRouter configuration
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
            create: (_) =>
                ProductsBloc(httpClient: Dio())..add(ProductsFetched()),
            child: ProductsPage()),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => BlocProvider(
            create: (_) {
              var productId = int.parse(state.pathParameters["id"]!);
              return ProductDetailPageBloc(
                  productId: productId, httpClient: Dio())
                ..add(ProductDetailPageFetch());
            },
            child: const ProductDetailPage()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
