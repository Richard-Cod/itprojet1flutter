import 'package:flutter/foundation.dart';
import 'package:itprojet1/manager/cartLocalService.dart';
import 'package:itprojet1/model/CartItem.dart';
import 'package:itprojet1/model/User.dart';
import 'package:itprojet1/model/category.dart';
import 'dart:collection';

class AuthDataNotifier extends ChangeNotifier {
  User _user;

  User get user => _user;

  set user(User value) {
    _user = value;
    notifyListeners();
  }
}
