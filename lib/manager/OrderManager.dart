import 'dart:io';

import 'package:itprojet1/model/CartItem.dart';
import 'package:itprojet1/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:itprojet1/constants.dart';

class OrderManager {
  Future postOrder(data) async {
    final url = '${K_API_URL}/orders';
    //final url = "https://jsonplaceholder.typicode.com/todos/";

    var response = await http.post(url,
//        headers: <String, String>{
//          'Content-Type': 'application/json; charset=UTF-8',
//          'Authorization': 'Bearer $token',
//        },
        body: jsonEncode(
            {'user': data['user'], 'cart_items': data['cart_items']}));

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //return CartItem.fromJson(json.decode(response.body));
      return json.decode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print("Erreur ${response.body}");
      throw Exception('Failed to post Order');
    }
  }
}
