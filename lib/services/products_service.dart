import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-2c3ea-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = false;
  bool isSaving = false;
  File? newPictureFile;

  //?lo esta realizando con el provider
  //? tambien puede realizarse a traves de los argumentos de las rutas para popular la pantalla detalles
  late Product selectedProduct;

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

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    // logica
    if (product.id == null) {
      // es necesario crear el producto
      await createProduct(product);
    } else {
      //actualizar producto
      await updateProduct(product);
    }

    //

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, "products/${product.id}.json");
    final response = await http.put(url, body: product.toJson());
    final decodedData = response.body;
    print(decodedData);

    //todo:actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, "products.json");
    final response = await http.post(url, body: product.toJson());

    final decodedData = json.decode(response.body);
    print(decodedData);

    //todo:actualizar el listado de productos
    product.id = decodedData['name'];
    products.add(product);

    return product.id!;
  }

  //? paso intermedio para el preview
  void updateSelectedProductImage(String path) {
    //? crea el archivo que lo obtiene del path del ImagePicker

    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dcxfnow0a/image/upload?upload_preset=kvuskip3');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
