import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:itprojet1/constants.dart';
import 'package:itprojet1/manager/CategoryManager.dart';
import 'package:itprojet1/manager/ProductManager.dart';
import 'package:itprojet1/manager/cartLocalService.dart';
import 'package:itprojet1/model/CartData.dart';
import 'package:itprojet1/model/CartItem.dart';

import 'dart:async';

import 'package:itprojet1/model/category.dart';
import 'package:itprojet1/pages/CategoryProducts.dart';
import 'package:itprojet1/pages/Login.dart';
import 'package:itprojet1/pages/OneProduct.dart';
import 'package:itprojet1/pages/ShoppingCartPage.dart';
import 'package:provider/provider.dart';

import 'package:itprojet1/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CategoryManager _cm = CategoryManager();
  ProductManager _pm = ProductManager();

  Future _categoriesFetched;
  Future _productsFetched;

  User _user;
  String _token;

  _getCategories() async {
    return _cm.fetchCategories();
  }

  _getProducts() async {
    return _pm.fetchProducts();
  }

  _loadUser() async {
    final prefs = await _prefs;
    setState(() {
      _user = User.fromJson(json.decode(prefs.get("current_user")));
    });
    print("le user $_user");
  }

  _loadToken() async {
    final prefs = await _prefs;
    _token = prefs.get("token");
    print("le token $_token");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categoriesFetched = _getCategories();
    _productsFetched = _getProducts();

    _loadUser();
    _loadToken();

    RepositoryServiceCart.getAllCartItems().then((value) {
      print("Le resultat de la bdd est :  ");
      Provider.of<CartDataNotifier>(context, listen: false).cartItems = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey ${_user != null ? _user.username : "....."}"),
        backgroundColor: kPrimaryColor,
        leading: Icon(Icons.menu),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.notifications_active),
            onTap: () {
              print("Button de notification $_token");
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Icon(Icons.filter_list),
            onTap: () {
              print("Button de Filtre");
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            child: Icon(Icons.clear),
            onTap: () {
              print("Button de Deconnexion");
              _prefs.then((value) => value.clear());

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingCartPage(),
                ),
              );
            },
            child: Badge(
              badgeContent: Text(
                Provider.of<CartDataNotifier>(context)
                    .cartItemsCount
                    .toString(),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              child: Icon(Icons.shopping_cart),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10.0,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          size: 30.0,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tapez votre recherche',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                HeadWidget(
                  leading: "Categories",
                  trailingFunction: () {
                    print("Voir toutes categories");
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                FutureBuilder(
                  future: _categoriesFetched,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Color(0x00fafafa),
                        elevation: 32.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Category category = snapshot.data[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryProductsPage(category),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Card(
                                    elevation: 0.0,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                "${category.image}",
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          color: kDifferentColors[index],
                                        ),
                                        Center(
                                          child: Container(
                                            child: Text(
                                              "${category.name}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10.0,
                              );
                            },
                            itemCount: snapshot.data.length,
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
                SizedBox(
                  height: 15.0,
                ),
                HeadWidget(
                  leading: "Populaires",
                  trailingFunction: () {
                    print("Voir tous populaires");
                  },
                ),
                FutureBuilder(
                  future: _productsFetched,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Color(0x00fafafa),
                        elevation: 32.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 210.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Product product = snapshot.data[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OneProductPage(
                                        productId: product.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: Card(
                                            elevation: 0.0,
                                            child: Container(
                                              height: 150.0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
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
                                          product.name,
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10.0,
                              );
                            },
                            itemCount: snapshot.data.length,
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
                HeadWidget(
                  leading: "Meilleures ventes",
                  trailingFunction: () {
                    print("Voir tous meilleures ventes");
                  },
                ),
                FutureBuilder(
                  future: _productsFetched,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Color(0x00fafafa),
                        elevation: 32.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 210.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Product product = snapshot.data[index];

                              return Card(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Card(
                                          elevation: 0.0,
                                          child: Container(
                                            height: 150.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
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
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 10.0,
                              );
                            },
                            itemCount: snapshot.data.length,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeadWidget extends StatelessWidget {
  const HeadWidget({
    Key key,
    this.leading,
    this.trailingFunction,
  }) : super(key: key);

  final leading;
  final trailingFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              leading,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: trailingFunction,
              child: Text(
                "Voir Tout",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
