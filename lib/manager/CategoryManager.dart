import 'package:itprojet1/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:itprojet1/constants.dart';

class CategoryManager {
  Future fetchCategories() async {
    final url = '${K_API_URL}/categories';
    //final url = "https://jsonplaceholder.typicode.com/todos/";

    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      var result = [];
      for (var jsonCategory in jsonResponse) {
        result.add(Category.fromJson(jsonCategory));
      }
      return result;
    } else {
      throw Exception('Failed to load Category');
    }
  }
}
