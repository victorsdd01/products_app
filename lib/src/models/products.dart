
import 'dart:convert';

class Products{

  // String id;
  String name;
  String image;
  double price;
  String description;
  bool isAvailable;
  String? id;


  Products({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.isAvailable,
    this.id
  });
  factory Products.fromJson(String json) => Products.fromJson(jsonDecode(json));
  factory Products.fromMap(Map<String,dynamic> json ) => Products(
    name: json['name'],
    image: json['image'], 
    price: json['price'], 
    description: json['description'],
    isAvailable: json['isAvailable']
  );

  Map<String,dynamic> topMap() => {
    'name' : name,
    'image': image,
    'price': price,
    'description': description,
    'isAvailable': isAvailable,
  };


}