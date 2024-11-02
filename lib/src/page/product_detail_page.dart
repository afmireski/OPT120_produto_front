import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opt120_produto_front/src/bloc/productsDetailPage/product_detail_page_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProductDetailPageBloc>().add(ProductDetailPageInit());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Produto'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          backgroundColor: Colors.purple[600],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              context.go('/');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                context
                    .read<ProductDetailPageBloc>()
                    .add(ProductDetailPageFetch());
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailPageBloc, ProductDetailPageState>(
            builder: (context, state) {
          switch (state.status) {
            case ProductDetailPageStatus.fetched:
              var product = state.product!;

              return Center(
                  child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "R\$ ${(product.price / 100).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Em estoque ${product.stock}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      "Criado em ${DateFormat('dd/MM/yyyy').format(product.createdAt)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ));
            case ProductDetailPageStatus.failure:
              return const Center(
                child: Text('failed to fetch product'),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }));
  }
}
