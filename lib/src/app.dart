import 'package:flutter/material.dart';
import 'ui/inicial.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.amberAccent),
      home: Scaffold(
        body: Inicial(),
      ),
    );
  }
}