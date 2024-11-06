# opt120_produto_front

Frontend do projeto inicial da disciplina de Desenvolvimento Móvel do curso de Bacharelado em Ciências da Computação.

## Setup

* Caso precise instalar o flutter, siga a documentação oficial [aqui](https://docs.flutter.dev/get-started/install).

```bash
# Clone o repositório
git clone https://github.com/afmireski/OPT120_produto_front.git
    # ou
git clone git@github.com:afmireski/OPT120_produto_front.git

cd ./OPT120_produto_front

# Prepare o arquivo de .env
cp ./.env/.env.example .env/.env

# Defina as variáveis de ambiente que desejar
```

* Suba a API como descrito no [repositório da API](https://github.com/afmireski/OPT120-produto-api).
* Se usar o docker, defina como API_URL o endereço do container: `http://<ip-container>:<sua-porta>`
* Se usar a api localmente, defina como API_URL o endereço local: `http://<127.0.0.1>:<sua-porta>`
* Para facilitar o carregamento da .env, foi definido um [launch.json](.vscode/launch.json).
    * Existe uma configuração que roda o emulador e outra que roda no Navegador.
    * Em CHROME_EXECUTABLE passe o caminho para o executável do seu chrome.
* Se sua IDE identificar automaticamente os devices, pode tentar executar sem o launch.
* Você também pode passar o IP da API diretamente, modificando o arquivo [enviroment.dart](./lib//config/environment.dart):
```dart
final class Environment {
  static const String apiUrl = String.fromEnvironment('IP da sua API');
}
```

* Após definir a variável de ambiente é só buildar o projeto.

