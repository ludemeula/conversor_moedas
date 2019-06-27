import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=5652f7fc';

void main() async {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color(0xffffff6b),
        appBar: AppBar(
          title: Text(
            '\$ Conversor de Moedas \$',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xfffcd734),
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    'Carregando Dados...',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Erro ao Carregar Dados...',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ));
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
                          TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                labelText: 'Reais (R\$)',
                                helperText: 'Insira o Valor em Reais (R\$)',
                                border: OutlineInputBorder(),
                                prefixText: 'R\$ '),
                            style: TextStyle(fontSize: 20, color: Colors.black),
//                            controller: weightController,
//                            validator: (value) {
//                              if (value.isEmpty) {
//                                return 'Insira o Peso (kg)';
//                              }
//                            },
                          )
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
