import 'package:flutter/material.dart';

import '../widgets/product_grid_view.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: ProductGridView(),
    );
  }
}
