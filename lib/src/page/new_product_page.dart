import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opt120_produto_front/src/bloc/newProductPage/new_product_page_bloc.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Produto'),
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
              context.read<NewProductPageBloc>().add(NewProductPageInit());
            },
          ),
        ],
      ),
      body: BlocBuilder<NewProductPageBloc, NewProductPageState>(
        builder: (context, state) {
          if (state.status == NewProductPageStatus.initial) {
            return Center(
              child: Container(
                color: Colors.red,
              ),
            );
          }
          if (state.status == NewProductPageStatus.saved) {
            return const Center(
              child: Text('Produto salvo com sucesso!'),
            );
          }

          return const Center(
            child: Text('Erro ao salvar produto!'),
          );
        },
      ),
    );
  }
}
