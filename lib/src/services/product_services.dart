// ignore_for_file: unused_field


import 'package:dio/dio.dart';
import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/ui/pages/pages.dart';

class ProductServices extends ChangeNotifier {
  final String baseUrl = "https://productsapp-27b6d-default-rtdb.firebaseio.com";
  final Dio dio = Dio();
  final List<Products> products = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setIsLoading (bool value) {
     _isLoading = value;
     notifyListeners();
  }

  Future<List<Products>> loadProducts() async {
    try {
      final response = await dio.get('$baseUrl/products.json');
      final Map<String, dynamic> productMap = response.data;
      productMap.forEach((key, value) {
        final currentProduct = Products.fromMap(value);
        currentProduct.id = key;
        products.add(currentProduct);
      });
      return products;
    } on Exception{
      print("something wrong to get all product list ❌");
      return [];
    }
  }
}