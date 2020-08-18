import 'package:itprojet1/manager/ProductManager.dart';
import 'package:itprojet1/manager/database_creator.dart';
import 'package:itprojet1/model/category.dart';

class CartItem {
  int id;
  Product product;
  int qte;
  CartItem({this.id, this.product, this.qte});

  int get totalPrice {
    return product.price * qte;
  }

  void attributeProduct(product_id) async {
    print("productId $product_id");
    final productFetched = await ProductManager().fetchOneProduct(product_id);
    product = productFetched;
    print("Le produit fetched $productFetched ");
  }

  CartItem.fromJson(Map<String, dynamic> json) {
    print("Le json a vybsé $json");
    id = json[DatabaseCreator.id];
    int product_id = json[DatabaseCreator.product_id];

    if (product_id != null) {
      attributeProduct(product_id);
    } else {
      product = Product.fromJson(json['product']);
    }
    qte = int.parse(json[DatabaseCreator.qte]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product'] = this.product.toJson();
    data['qte'] = this.qte;
    return data;
  }
}
