
class Products{

  final String image;
  final String price;
  final String description;
  final bool isAvailable;


  Products({
    required this.image,
    required this.price,
    required this.description,
    required this.isAvailable,
  });

  factory Products.fromMap(Map<String,dynamic> json ) => Products(
    image: json['image'], 
    price: json['price'], 
    description: json['description'],
    isAvailable: json['isAvailable']
  );

  Map<String,dynamic> topMap() => {
    'image': image,
    'price': price,
    'description': description,
    'isAvailable': isAvailable,
  };


}