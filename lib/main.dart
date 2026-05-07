import 'package:flutter/material.dart';
import 'package:recipe_app/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recipe App",
      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),
      home: LoginPage(),
    );
  }
}
