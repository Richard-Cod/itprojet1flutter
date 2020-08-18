import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itprojet1/constants.dart';
import 'package:itprojet1/manager/CartItemManager.dart';
import 'package:itprojet1/manager/OrderManager.dart';
import 'package:itprojet1/model/AuthData.dart';
import 'package:itprojet1/model/CartData.dart';
import 'package:itprojet1/model/CartItem.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  //CartItem order = Order();

  void _decreaseOrderItemQuantity(CartItem item) {
    if (item.qte > 0) {
      Provider.of<CartDataNotifier>(context, listen: false)
          .updateCartItemQte(item, item.qte - 1);
    }
  }

  void _increaseOrderItemQuantity(CartItem item) {
    if (item.qte > 0) {
      Provider.of<CartDataNotifier>(context, listen: false)
          .updateCartItemQte(item, item.qte + 1);
    } else {
      _removeOrderItem(item);
    }
  }

  void _removeOrderItem(CartItem item) {
    Provider.of<CartDataNotifier>(context, listen: false).removeCartItem(item);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showDialog(CartItem item) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Voulez-vous vraiment supprimer ?"),
          content: new Text("${item.qte} X ${item.product.name} "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Supprimer"),
              onPressed: () {
                _removeOrderItem(item);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();

    return Scaffold(
      body: Builder(
        builder: (context) => SafeArea(
          child: Container(
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  fit: BoxFit.fill,
//                  image: NetworkImage(""),
//                ),
//              ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Commande",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    "${dateTime.toUtc()}",
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "+ Ajouter au panier",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    child: Provider.of<CartDataNotifier>(context, listen: false)
                                .cartItemsCount >
                            0
                        ? Text("Passer votre commande")
                        : Text("Commande Indisponible (panier vide)"),
                    onPressed: Provider.of<CartDataNotifier>(context,
                                    listen: false)
                                .cartItemsCount >
                            0
                        ? () async {
                            print("Commande démarré");
                            CartItemManager cim = CartItemManager();
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            List<int> listOfIds = List<int>();
                            for (CartItem item in Provider.of<CartDataNotifier>(
                                    context,
                                    listen: false)
                                .cartItems) {
                              int id = (await cim.postCartItem(
                                      item, sharedPreferences.get("token")))
                                  .id;
                              listOfIds.add(id);
                            }

                            print(
                                "Donc on Commande $listOfIds par ${Provider.of<AuthDataNotifier>(context, listen: false).user.toJson()}");

                            OrderManager om = OrderManager();
                            final Map<String, dynamic> data =
                                new Map<String, dynamic>();
                            data['user'] = Provider.of<AuthDataNotifier>(
                                    context,
                                    listen: false)
                                .user
                                .id;
                            data['cart_items'] = listOfIds;

                            await om.postOrder(data);

                            Provider.of<CartDataNotifier>(context,
                                    listen: false)
                                .cartItems = [];

                            final snackBar = SnackBar(
                                content:
                                    Text('Votre commande a été effectué 😁!'));
                            Scaffold.of(context).showSnackBar(snackBar);
                          }
                        : null,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: Provider.of<CartDataNotifier>(context, listen: false)
                                .cartItemsCount ==
                            0
                        ? Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Votre panier est vide",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Icon(
                                  Icons.local_drink,
                                  size: 100.0,
                                ),
//                                  Image(
//                                    image: NetworkImage(
//                                      "https://www.nicepng.com/png/detail/322-3224210_your-cart-is-currently-empty-empty-shopping-cart.png",
//                                    ),
//                                  ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: Provider.of<CartDataNotifier>(context,
                                    listen: false)
                                .cartItemsProductCounts,
                            itemBuilder: (context, index) {
                              print(Provider.of<CartDataNotifier>(context,
                                      listen: false)
                                  .cartItemsProductCounts);

                              var cartItems = Provider.of<CartDataNotifier>(
                                      context,
                                      listen: false)
                                  .cartItems;

                              return OrderItemComponent(
                                cartItem: cartItems[index],
                                increaseQuantity: () =>
                                    _increaseOrderItemQuantity(
                                        cartItems[index]),
                                decreaseQuantity: () =>
                                    _decreaseOrderItemQuantity(
                                        cartItems[index]),
                                onRemove: () => _showDialog(cartItems[index]),
                              );
                            }),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total :",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "${Provider.of<CartDataNotifier>(context).cartItemsTotalPrice} f",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderItemComponent extends StatelessWidget {
  final Function increaseQuantity;
  final Function decreaseQuantity;
  final Function onRemove;

  final CartItem cartItem;

  const OrderItemComponent({
    Key key,
    this.cartItem,
    this.increaseQuantity,
    this.decreaseQuantity,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 10.0,
                  color: Colors.black87,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage("${cartItem.product.image}"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Text(
                      "${cartItem.product.name}",
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.0),
                            child: Container(
                              width: 20.0,
                              color: Color.fromRGBO(0, 0, 0, 0.02),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: decreaseQuantity,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          "${cartItem.qte}",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2.0),
                            child: Container(
                              width: 20.0,
                              color: Color.fromRGBO(0, 0, 0, 0.02),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          onTap: increaseQuantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      "${cartItem.totalPrice} f",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: onRemove,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          color: Colors.grey,
                          child: Icon(
                            Icons.clear,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
