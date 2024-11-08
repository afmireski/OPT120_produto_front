import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opt120_produto_front/src/bloc/productsPage/products_bloc.dart';
import 'package:opt120_produto_front/src/widgets/http_dialog.dart';
import 'package:opt120_produto_front/src/widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductsBloc>().add(ProductsInit());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.purple[600],
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<ProductsBloc>().add(ProductsFetched());
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/new_product');
          },
          backgroundColor: Colors.purple[300],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body:
            BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
          switch (state.status) {
            case ProductsPageStatus.success:
              return Center(
                  child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        var product = state.products[index];

                        return ProductCard(
                          product: product,
                          onTap: () => _productCardAction(product.id, context),
                        );
                      }));
            case ProductsPageStatus.failure:
              var error = state.error!;
              return HttpDialog(
                httpCode: error.httpCode,
                message: error.message,
                onOk: () {
                  context.read<ProductsBloc>().add(ProductsFetched());
                },
                details: error.details,
              );
            case ProductsPageStatus.empty:
              return const Center(
                child: Text('Infelizmente não há produtos cadastrados'),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }));
  }

  _productCardAction(int productId, BuildContext context) {
    context.go('/product/$productId');
  }
}
