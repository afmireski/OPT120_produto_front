import 'package:flutter/material.dart';

class HttpDialog extends StatelessWidget {
  final int httpCode;
  final String message;
  final List<String>? details;
  final VoidCallback onOk;

  const HttpDialog(
      {Key? key,
      required this.httpCode,
      required this.message,
      required this.onOk,
      this.details = const <String>[]})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(_title()),
      icon: _icon(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 10),
            if (details != null && details!.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: details!.map((detail) => Text(' - $detail')).toList(),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onOk,
          child: const Text('Entendi'),
        ),
      ],
    );
  }

  Widget _icon() {
    switch (httpCode) {
      case 200:
      case 201:
      case 204:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 30,
        );
      case 400:
        return Icon(Icons.warning, color: Colors.yellow[700], size: 30);
      case 401:
        return const Icon(Icons.lock_person, color: Colors.red, size: 30);
      case 403:
        return Icon(Icons.shield, color: Colors.orange[800], size: 30);
      case 404:
        return Icon(Icons.search_off, color: Colors.orange[800], size: 30);
      case 500:
        return const Icon(Icons.public_off, color: Colors.red, size: 30);
      default:
        return const Icon(Icons.error, color: Colors.red, size: 30);
    }
  }

  String _title() {
    switch (httpCode) {
      case 200:
      case 201:
      case 204:
        return 'Sucesso';
      case 400:
        return 'Dados inválidos';
      case 401:
        return 'Não autorizado';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Não encontrado';
      case 500:
        return 'Erro interno do servidor';
      default:
        return 'Erro';
    }
  }
}
