// ignore_for_file: unused_field, prefer_final_fields
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/ui/pages/pages.dart';

class ProductServices extends ChangeNotifier {

  final String baseUrl = "https://productsapp-27b6d-default-rtdb.firebaseio.com";
  final Dio dio = Dio();
  List<Products> products = [];
  List<String> productsId = [];
  File? selectedImage;
  bool _isLoading = true;
  bool _deleteProduct = false;
  bool _productListIsEmpty = false;
  bool get isLoading => _isLoading;
  bool get getDeleteProduct => _deleteProduct;
  bool get productListIsEmpty => _productListIsEmpty;

  set setDeleteProduct(bool value){
    _deleteProduct = value;
    notifyListeners();
  }
  set setSelectedImage(File? value){
    selectedImage = value;
    notifyListeners();
  }

  ProductServices(){
    loadProducts();
  }

  Future<List<Products>> loadProducts() async {
    try {
      final response = await dio.get('$baseUrl/products.json');
      if(response.data != null){
        final Map<String, dynamic> productMap = response.data;
        productMap.forEach((key, value) {
          final currentProduct = Products.fromMap(value);
          currentProduct.id = key;
          products.add(currentProduct);
          productsId.addAll([currentProduct.id!]);
        });
        _isLoading = false;
        notifyListeners();
      }
      if(response.data == null){
        _isLoading = false;
        _productListIsEmpty = true;
        notifyListeners();
      }
      return products;
    } on Exception{
      print("something wrong to get all product list ❌");
      return [];
    }
  }

    Future<bool> updateProduct(Products product) async {
      try{
        await dio.put('$baseUrl/products/${product.id}.json', data: jsonEncode(product.topMap()));
        final index = products.indexWhere((element) => element.id == product.id);
        products[index] = product;
        notifyListeners();
        return true;
      } on Exception{
        print("something wrong trying to update the product ${product.id} ❌");
        return false;
      }
  }

  Future<bool> addNewProduct(Products product) async {
    try{
      final resp = await dio.post('$baseUrl/products.json', data: jsonEncode(product.topMap()));
      product.id =  resp.data['name'];
      products.add(product);
      productsId.add(product.id!);
      _productListIsEmpty = false;
      notifyListeners();
      return true;
    }on Exception{
      print("something wrong to add new product ❌");
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try{
      await dio.delete('$baseUrl/products/$id.json',data:{"id": id});
      final index = products.indexWhere((element) => element.id == id);
      products.removeAt(index);
      if(products.isEmpty){
        _productListIsEmpty = true;
      }
      notifyListeners();
      return true;
    }on Exception {
      print("something wrong to delete $id product ❌");
      return false;
    }
  }

  Future<bool> deleteAllProducts() async {
    try{
      await dio.delete('$baseUrl/products.json',data:{ "ids": productsId});
      products = [];
      _productListIsEmpty = true;
      notifyListeners();
      return true;
    }on Exception{
      print("something wrong to delete all products ❌");
      return false;
    }
  }

  Future<void> putImageFromGallery() async {
    try{
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        selectedImage = File(image.path);
        notifyListeners();
        print("image: $selectedImage");
      }
    }on Exception {
      print("something wrong trying to select an image from gallery adding a new project ❌");
    }
  }

  Future<void> getImageFromGallery(Products product) async {
    try{
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if(image != null){
        selectedImage = File(image.path);
        product.image = selectedImage!.path;
        await dio.put('$baseUrl/products/${product.id}.json',data: jsonEncode(product.topMap()));
        final index = products.indexWhere((element) => element.id == product.id);
        products[index].image = selectedImage!.path;
        notifyListeners();
      }
    }on Exception catch(e){
      print("something wrong to get image from gallery ❌ $e");
    }
  }
}