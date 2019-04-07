import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance?key=7c3f55b2";

void main() async{

  print (await getDollar());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dollar;
  double euro;

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text){
    double real = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar) .toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realController.text = (euro * this.euro) .toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true
      ),
      body: FutureBuilder<Map>(
          future: getDollar(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregendo dados"),
                  );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text("Carregendo dados"),
                  );
                }else{
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,),
                        buildTextField("Real", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dollar", "US\$", dollarController, _dollarChanged),
                        Divider(),
                        buildTextField("Euro", "EU\$", euroController, _euroChanged)

                      ],
                    ) ,
                  );
                }
            }
            }

          ),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function f){
  return TextField(
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
    style: TextStyle(color: Colors.amber),
    controller: controller,
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

Future<Map> getDollar() async {
   http.Response response = await http.get(request);
   return (json.decode(response.body));
}

