import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opt120_produto_front/src/bloc/productsPage/products_bloc.dart';

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
      context.read<ProductsBloc>().add(ProductInit());
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
              icon: const Icon(Icons.refresh, color: Colors.white,),
              onPressed: () {
                context.read<ProductsBloc>().add(ProductsFetched());
              },
            ),
          ],
        ),
        body:
            BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
          switch (state.status) {
            case ProductStatus.success:
              return Center(
                  child: ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                        );
                      }));
            case ProductStatus.failure:
              return const Center(
                child: Text('failed to fetch products'),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }));
  }
}
