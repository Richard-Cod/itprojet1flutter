import 'dart:convert' as convert;

class Category {
  int id;
  String name;
  String image;
  String createdAt;
  String updatedAt;
  List<Product> products;

  Category(
      {this.id,
      this.name,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.products});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }
}

class Product {
  int id;
  String name;
  int price;
  String image;
  String description;
  var category;
  String createdAt;
  String updatedAt;

  Product(
      {this.id,
      this.name,
      this.price,
      this.image,
      this.description,
      this.category,
      this.createdAt,
      this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = int.parse(json['price']);
    image = json['image'];

    category = json['category'] is int
        ? json['category']
        : Category.fromJson(json['category']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category'] = this.category;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
