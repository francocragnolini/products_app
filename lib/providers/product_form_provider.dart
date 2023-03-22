import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:products_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    log("$value");
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    print('ProductFormProvider: $product.name');
    print('ProductFormProvider: $product.price');
    print('ProductFormProvider: $product.available');

    return productFormKey.currentState?.validate() ?? false;
  }
}
