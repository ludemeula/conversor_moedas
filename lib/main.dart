import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=5652f7fc';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.black, primaryColor: Color(0xffe0e0e0)),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void _clearAll() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '\$ Conversor de Moedas \$',
//            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xffffca28),
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return buildMessage('Carregando Dados...');
                default:
                  if (snapshot.hasError) {
                    return buildMessage('Erro ao Carregar Dados...');
                  } else {
                    dolar =
                        snapshot.data['results']['currencies']['USD']['buy'];
                    euro = snapshot.data['results']['currencies']['EUR']['buy'];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.attach_money, size: 100),
                          buildTextField(
                              'Real (R\$)',
                              'Insira o Valor em Real (R\$)',
                              'R\$ ',
                              realController, _realChanged),
                          Divider(),
                          buildTextField(
                              'Dólar (US\$)',
                              'Insira o Valor em Dólar (US\$)',
                              'US\$ ',
                              dolarController, _dolarChanged),
                          Divider(),
                          buildTextField(
                              'Euro (R\$)',
                              'Insira o Valor em Euro (€)',
                              '€ ',
                              euroController, _euroChanged)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Future<Map> getData() async {
  http.Response response = await http.get(request);

  return json.decode(response.body);
}

Widget buildTextField(String label, String helper, String prefix,
    TextEditingController controller, Function function) {
  return TextField(
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(fontSize: 20),
    controller: controller,
    onChanged: function,
  );
}

Widget buildMessage(final String message) {
  return Center(
      child: Text(
    message,
    style: TextStyle(fontSize: 25),
    textAlign: TextAlign.center,
  ));
}
