import 'package:flutter/material.dart';
import 'package:itprojet1/manager/ProductManager.dart';
import 'package:itprojet1/model/CartData.dart';
import 'package:itprojet1/model/CartItem.dart';
import 'package:itprojet1/model/category.dart';
import 'package:provider/provider.dart';

class OneProductPage extends StatefulWidget {
  final productId;

  const OneProductPage({Key key, this.productId}) : super(key: key);

  @override
  _OneProductPageState createState() => _OneProductPageState(productId);
}

class _OneProductPageState extends State<OneProductPage> {
  final productId;

  ProductManager _pm = ProductManager();
  Future _productFetched;

  _OneProductPageState(this.productId);

  _getProduct() async {
    return _pm.fetchOneProduct(productId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _productFetched = _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Un produit"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _productFetched,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Product product = snapshot.data;
              return Card(
                color: Color(0x00fafafa),
                elevation: 32.0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500.0,
                  child: Card(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Card(
                              elevation: 0.0,
                              child: Container(
                                height: 150.0,
                                width: MediaQuery.of(context).size.width * 0.4,
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
                          Text(
                            "${product.description}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            "Catégorie : ${product.category.name}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              print("Ajout au panier effectué");
                              Provider.of<CartDataNotifier>(context,
                                      listen: false)
                                  .addCartItem(CartItem(
                                product: product,
                                qte: 1,
                              ));
                              final snackBar = SnackBar(
                                  content:
                                      Text('${product.name} a été ajouté 😁!'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.shopping_cart),
                            label: Text("Ajouter au panier"),
                          )
                        ],
                      ),
                    ),
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
