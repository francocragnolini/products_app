import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2c3ea-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  bool isLoading = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, "products.json");
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
      // log(products[0].name);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }
}
