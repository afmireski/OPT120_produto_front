import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:opt120_produto_front/src/bloc/productsDetailPage/product_detail_page_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opt120_produto_front/src/models/products.dart';
import 'package:opt120_produto_front/src/widgets/http_dialog.dart';

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
        backgroundColor: Colors.grey[200],
        body: BlocBuilder<ProductDetailPageBloc, ProductDetailPageState>(
            builder: (context, state) {
          switch (state.status) {
            case ProductDetailPageStatus.fetched:
              return _fetchedWidget(state.product!);
            case ProductDetailPageStatus.failure:
              var error = state.error!;
              return HttpDialog(
                httpCode: error.httpCode,
                message: error.message,
                onOk: () {
                  context
                      .read<ProductDetailPageBloc>()
                      .add(ProductDetailPageFetch());
                },
                details: error.details,
              );
            case ProductDetailPageStatus.deleted:
              return HttpDialog(
                  httpCode: 204,
                  message: 'Produto excluído com sucesso',
                  onOk: () {
                    context.go('/');
                  });
            case ProductDetailPageStatus.updated:
              return HttpDialog(
                  httpCode: 200,
                  message: 'Produto atualizado com sucesso',
                  onOk: () {
                    context
                        .read<ProductDetailPageBloc>()
                        .add(ProductDetailPageFetch());
                  });
            case ProductDetailPageStatus.updatedRequested:
              return _updateRequestedWidget(state.tmpProduct!);
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }));
  }

  Widget _fetchedWidget(Product product) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<ProductDetailPageBloc>()
                        .add(ProductDetailPageEditRequested());
                  },
                  tooltip: 'Editar produto',
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.purpleAccent,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "R\$ ${(product.price / 100).toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Em estoque ${product.stock}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Criado em ${DateFormat('dd/MM/yyyy').format(product.createdAt)}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: IconButton(
                alignment: Alignment.center,
                onPressed: () => _showDeleteConfirmationDialog(context),
                tooltip: 'Excluir produto',
                icon: const Icon(Icons.delete, size: 30, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _updateRequestedWidget(Product product) {
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
                  initialPickerDateTime: product.createdAt,
                  initialValue: product.createdAt,
                  dateFormat: DateFormat('dd/MM/yyyy'),
                  lastDate: DateTime.now(),
                  mode: DateTimeFieldPickerMode.date,
                  decoration: const InputDecoration(
                    labelText: 'Data de criação',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    product = product.copyWith(createdAt: value);
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<ProductDetailPageBloc>()
                          .add(ProductDetailPageFetch());
                    },
                    style: OutlinedButton.styleFrom(
                      iconColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar',
                        style: TextStyle(color: Colors.red)),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      context
                          .read<ProductDetailPageBloc>()
                          .add(ProductDetailPageUpdateRequested(product));
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
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext builderContext) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content: const Text('Deseja realmente excluir este produto?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(builderContext).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<ProductDetailPageBloc>()
                    .add(ProductDetailPageDeleteRequested());
                Navigator.of(builderContext).pop();
              },
              child: const Text(
                'Excluir',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
