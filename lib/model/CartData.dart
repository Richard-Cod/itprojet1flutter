import 'package:flutter/foundation.dart';
import 'package:itprojet1/manager/cartLocalService.dart';
import 'package:itprojet1/model/CartItem.dart';
import 'package:itprojet1/model/category.dart';
import 'dart:collection';

class CartDataNotifier extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  UnmodifiableListView<CartItem> get cartItems {
    return UnmodifiableListView(_cartItems);
  }

  int get cartItemsProductCounts {
    return _cartItems.length;
  }

  int get cartItemsCount {
    int result = 0;
    for (CartItem cartItem in _cartItems) {
      result += cartItem.qte;
    }
    return result;
  }

  int get cartItemsTotalPrice {
    int result = 0;
    for (CartItem cartItem in _cartItems) {
      result += cartItem.product.price * cartItem.qte;
    }
    return result;
  }

  CartItem searchItemInCart(CartItem cartItem) {
    CartItem search = _cartItems.firstWhere(
        (item) => item.product.id == cartItem.product.id,
        orElse: () => null);
    return search;
  }

  void addCartItem(CartItem newCartItem) {
    final CartItem search = searchItemInCart(newCartItem);

    if (search != null) {
      print(newCartItem.qte + 1);
      updateCartItemQte(search, search.qte + 1);
    } else {
      _cartItems.add(newCartItem);

      print("Enregistrons dans la bdd");
      RepositoryServiceCart.addCartItem(newCartItem);
    }
    notifyListeners();
  }

  void updateCartItemQte(CartItem cartItem, int newQte) {
    cartItem.qte = newQte;

    print("On met à jour la bdd ");
    RepositoryServiceCart.updateCartItem(cartItem);
    notifyListeners();
  }

  void removeCartItem(CartItem cartItem) {
    _cartItems.remove(cartItem);

    print("On supprime de ${cartItem.product.name} de la bdd ");
    RepositoryServiceCart.deleteCartItem(cartItem);
    notifyListeners();
  }

  set cartItems(List<CartItem> value) {
    _cartItems = value;
    notifyListeners();
  }
}
