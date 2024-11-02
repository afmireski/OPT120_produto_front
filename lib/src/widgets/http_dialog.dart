import 'package:flutter/material.dart';

class HttpDialog extends StatelessWidget {
  final int httpCode;
  final String message;
  final VoidCallback onOk;

  const HttpDialog({Key? key, required this.httpCode, required this.message, required this.onOk}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
      alignment: Alignment.center,
      title: Text(_title()),
      icon: _icon(),
      content: Text(message),
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
        return const Icon(Icons.check_circle, color: Colors.green);
      case 400:
        return Icon(Icons.warning, color: Colors.yellow[700]);
      case 401:
        return const Icon(Icons.lock_person, color: Colors.red);
      case 403:
        return Icon(Icons.shield, color: Colors.orange[800]);
      case 404:
        return Icon(Icons.search_off, color: Colors.orange[800]);
      case 500:
        return const Icon(Icons.public_off, color: Colors.red);
      default:
        return const Icon(Icons.error, color: Colors.red);
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