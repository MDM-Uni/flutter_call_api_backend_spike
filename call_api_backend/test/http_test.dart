import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async{
  var url = Uri.parse("http://localhost:8080/api/v1/customers");
  var customers = await http.get(url);
  dynamic json = jsonDecode(customers.body);
  print(json);
}