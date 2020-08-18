import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:itprojet1/model/AuthData.dart';
import 'package:itprojet1/model/CartData.dart';
import 'package:itprojet1/pages/Register.dart';
import 'package:itprojet1/pages/ShoppingCartPage.dart';
import 'package:provider/provider.dart';
import 'pages/Home.dart';
import 'package:itprojet1/constants.dart';
import 'package:itprojet1/manager/database_creator.dart';
import 'package:flutter/widgets.dart';

import 'pages/Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("On est ici ");
  await DatabaseCreator().initDatabase();

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartDataNotifier()),
        ChangeNotifierProvider(create: (_) => AuthDataNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
