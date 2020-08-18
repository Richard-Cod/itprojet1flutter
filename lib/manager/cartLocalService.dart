import 'package:itprojet1/model/CartItem.dart';

import 'package:itprojet1/manager/database_creator.dart';

class RepositoryServiceCart {
  static Future<List<CartItem>> getAllCartItems() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.cartTable} ''';
    final data = await db.rawQuery(sql);
    List<CartItem> cartItems = List();

    for (final node in data) {
      print("12-CartLocalservice ${node}");
      final cartItem = CartItem.fromJson(node);

      if (cartItem.product == null) {
        print("On supprime car pas de produit avec cet ID");
        deleteCartItem(cartItem);
      } else {
        cartItems.add(cartItem);
      }
    }
    return cartItems;
  }

  static Future<CartItem> getOneCartItem(int id) async {
    //final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    //WHERE ${DatabaseCreator.id} = $id''';
    //final data = await db.rawQuery(sql);

    final sql = '''SELECT * FROM ${DatabaseCreator.cartTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final cartItem = CartItem.fromJson(data.first);
    return cartItem;
  }

  static Future<void> addCartItem(CartItem cartItem) async {
    /* final sql = '''INSERT INTO ${DatabaseCreator.cartTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.product_id},
      ${DatabaseCreator.qte}
    )
    VALUES
    (
      ${cartItem.id},
      "${cartItem.product.id}",
      "${cartItem.qte}"
    )'''; */

    final sql = '''INSERT INTO ${DatabaseCreator.cartTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.product_id},
      ${DatabaseCreator.qte}
    )
    VALUES (?,?,?)''';
    List<dynamic> params = [cartItem.id, cartItem.product.id, cartItem.qte];

    final result = await db.rawInsert(sql, params);
    DatabaseCreator.databaseLog('Add cartItem', sql, null, result, params);
  }

  static Future<void> deleteCartItem(CartItem cartItem) async {
    /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/

    /* final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    '''; */

    final sql = '''DELETE FROM ${DatabaseCreator.cartTable} 
                    WHERE  ${DatabaseCreator.id} = ? ''';

    List<dynamic> params = [cartItem.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Delete cartItem', sql, null, result, params);
  }

  static Future<void> updateCartItem(CartItem cartItem) async {
    /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.name} = "${todo.name}"
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/

    final sql = '''UPDATE ${DatabaseCreator.cartTable}
    SET ${DatabaseCreator.qte} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [cartItem.qte, cartItem.id];
    final result = await db.rawUpdate(sql, params);

    DatabaseCreator.databaseLog('Update cartItem', sql, null, result, params);
  }

  static Future<int> cartItemsCount() async {
    final data = await db
        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.cartTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}
