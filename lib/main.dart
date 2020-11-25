import 'package:flutter/material.dart';
import 'package:moiverecommend/LoginPage.dart';
import 'package:moiverecommend/RootPage.dart';
import 'package:moiverecommend/SelectPage.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(),
    );
  }
}
