import 'dart:convert';
import 'package:call_api_backend/models/customer_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const stringUrl = "http://localhost:8080/api/v1/customers";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title:"Customers"),
    );
  }
}

Future<List<Customer>> getCustomers() async{
  var url = Uri.parse(stringUrl);
  var customers = await Future.delayed(
      const Duration(seconds:15),
      () => http.get(url),
  );
  dynamic json = jsonDecode(customers.body);
  List<Customer> listCustomers = [];
  for (Map<String, dynamic> customer in json) {
    listCustomers.add(Customer(customer['name'] ?? "", customer['email'] ?? "", customer['id'] ?? 0));
  }
  return listCustomers;
}

Widget listViewBuilder(context, snap) {
  if (snap.connectionState == ConnectionState.none || !snap.hasData || snap.data==null) {
    //print('project snapshot data is: ${snap.data}');
    return const Center(
      child: Text("Devi accendere il backend.\nLo spike sui Customers con Spring"),
    );
  }
  return ListView.builder(
    itemCount: snap.data!.length,
    itemBuilder: (context, index) {
      Customer customer = snap.data[index];
      return ListTile(
          title: Text("id ${customer.id} con nome ${customer.name}"),
          subtitle: Text("email: ${customer.email}"),
      );
    },
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: FutureBuilder(
          future: getCustomers(),
          builder: listViewBuilder,
        ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

