import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String recipeId;

  const DetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Detail')),
      body: Center(child: Text('Recipe ID: $recipeId')),
    );
  }
}
