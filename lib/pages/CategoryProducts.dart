import 'package:flutter/material.dart';
import 'package:itprojet1/manager/ProductManager.dart';
import 'package:itprojet1/model/category.dart';
import 'package:itprojet1/constants.dart';

class CategoryProductsPage extends StatefulWidget {
  final categoryId;

  CategoryProductsPage(this.categoryId);

  @override
  _CategoryProductsPageState createState() =>
      _CategoryProductsPageState(categoryId);
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final Category categoryFilter;
  _CategoryProductsPageState(this.categoryFilter);

  ProductManager _pm = ProductManager();
  Future _productsFetched;

  _getProducts() async {
    return _pm.fetchProductsByCategorie(categoryFilter);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productsFetched = _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catégorie : ${categoryFilter.name}"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: _productsFetched,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              var size = MediaQuery.of(context).size;
              if (snapshot.data.length == 0) {
                return Center(
                    child: Text(
                  "Aucun produit  '' ${categoryFilter.name} '' ",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ));
              }
              return Card(
                color: Color(0x00fafafa),
                elevation: 32.0,
                child: GridView.count(
                  childAspectRatio: (size.width * 0.5 / (size.height * 0.30)),
                  crossAxisCount: 2,
                  children: List.generate(
                    snapshot.data.length,
                    (index) {
                      Product product = snapshot.data[index];
                      return Card(
                        color: Colors.red,
                        child: Container(
                          color: Colors.green,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Card(
                                  elevation: 0.0,
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "${product.image}",
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "${product.price} fcfa",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                "${product.name}",
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Container(
                child: Text("Erreur"),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
