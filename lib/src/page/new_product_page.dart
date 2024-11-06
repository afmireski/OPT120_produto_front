import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opt120_produto_front/src/bloc/newProductPage/new_product_page_bloc.dart';
import 'package:opt120_produto_front/src/bloc/productsPage/products_bloc.dart';
import 'package:opt120_produto_front/src/models/product_body.dart';
import 'package:opt120_produto_front/src/widgets/http_dialog.dart';

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
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<NewProductPageBloc, NewProductPageState>(
        builder: (context, state) {
          switch (state.status) {
            case NewProductPageStatus.ready:
              return _newProductForm(state.productData!);
            case NewProductPageStatus.saved:
              return HttpDialog(
                  httpCode: 200,
                  message: 'Produto cadastrado com sucesso',
                  onOk: () {
                    context.go('/');
                  });
            case NewProductPageStatus.failure:
              var error = state.error!;
              return HttpDialog(
                httpCode: error.httpCode,
                message: error.message,
                onOk: () {
                  context.read<NewProductPageBloc>().add(NewProductPageInit());
                },
                details: error.details,
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget _newProductForm(ProductBody product) {
    return Center(
        child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            color: Colors.purple[600]!,
            width: 2,
          ),
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: product.description,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  product = product.copyWith(description: value);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.price.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Preço (centavos de R\$)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    return;
                  }

                  var price = int.parse(value);

                  product = product.copyWith(price: price);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.stock.toString(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Estoque',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    return;
                  }
                  var stock = int.parse(value);

                  product = product.copyWith(stock: stock);
                },
              ),
              const SizedBox(height: 10),
              DateTimeFormField(
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  initialPickerDateTime: DateTime.now(),
                  initialValue: product.createdAt,
                  dateFormat: DateFormat('dd/MM/yyyy'),
                  lastDate: DateTime.now(),
                  decoration: const InputDecoration(
                    labelText: 'Data de criação',
                    border: OutlineInputBorder(),
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  onChanged: (value) {
                    product = product.copyWith(createdAt: value);
                  }),
              const SizedBox(height: 20),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context
                        .read<NewProductPageBloc>()
                        .add(NewProductPageOnSave(product));
                  },
                  style: OutlinedButton.styleFrom(
                    iconColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar',
                      style: TextStyle(color: Colors.green)),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
