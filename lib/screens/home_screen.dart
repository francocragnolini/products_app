import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/products_service.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);

    if (productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //! metodo copy para romper la referencia con el producto en la lista
              //! cuando haces click sobre el producto el productsService.selectedProduct ya tiene
              //! un porducto en memoria
              productsService.selectedProduct =
                  productsService.products[index].copy();
              Navigator.pushNamed(context, "product_screen");
            },
            child: ProductCard(
              product: productsService.products[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Todo: crear un nuevo producto
          productsService.selectedProduct =
              Product(available: false, name: "", price: 0);
          //?
          Navigator.pushNamed(context, 'product_screen');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
