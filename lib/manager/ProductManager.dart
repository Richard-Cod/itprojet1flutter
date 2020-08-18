import 'package:itprojet1/constants.dart';
import 'package:itprojet1/model/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductManager {
  Future fetchProducts() async {
    final url = '${K_API_URL}/products';
    //final url = "https://jsonplaceholder.typicode.com/todos/";

    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      List<Product> result = [];
      for (var jsonProduct in jsonResponse) {
        result.add(Product.fromJson(jsonProduct));
      }
      return result;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  fetchProductsByCategorie(category) async {
    List<Product> products = await fetchProducts();
    return products.where((p) => p.category.id == category.id).toList();
  }

  fetchOneProduct(productId) async {
    final url = '${K_API_URL}/products/${productId}';
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return Product.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load Product');
    }
  }
}
