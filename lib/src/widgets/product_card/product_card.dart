import 'package:flutter/foundation.dart';
import 'package:productos_app/src/services/product_services.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.price,
    required this.description,
    required this.isAvailable,
    required this.image
  });


  final String price;
  final String description;
  final bool isAvailable;
  final String image;

  @override
  Widget build(BuildContext context) {

    final size =  MediaQuery.of(context).size;
    final ProductServices productServices = Provider.of<ProductServices>(context);
    return SizedBox(
      width: size.width,
      height: size.height * 0.40,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)
        ),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: image.contains("/Users") 
                ? Image.asset(image, fit: BoxFit.cover,) 
                : FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: '', 
                    image: image,
                    imageErrorBuilder: (context, error, stackTrace) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        Text('Something wrong trying to load the image',style: TextStyle(color: Colors.grey.shade500),),
                        Icon(Icons.image_not_supported_rounded,color: Colors.grey.shade500,)
                      ],
                    ),
                    placeholderErrorBuilder: (context, error, stackTrace)=> const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  ),
              ),
            ),
            productServices.getDeleteProduct ? Positioned(
              left: size.width  * 0.4,
              top: 0,
              child: Checkbox(
                value: true, 
                onChanged: (value){
                  if (kDebugMode) {
                    print("value: $value");
                  }
                }
              )
            )
            : const SizedBox(),
            Positioned(
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
                  color: isAvailable ? Colors.green.shade400 : Colors.amber.shade400,
                ),
                height: size.height * 0.05,
                width: size.width * 0.20,
                child:  Center(
                   child: Text( isAvailable ? 'Available' : 'No available', 
                   style: const TextStyle(color: Colors.white),
                   textAlign: TextAlign.center,
                  )
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                  color: Colors.deepPurple,
                ),
                height: size.height * 0.05,
                width: size.width * 0.20,
                child:  Center(child: Text(price, style: const TextStyle(color: Colors.white),)),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: size.height * 0.06,
                width: size.width * 0.80,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius:const BorderRadius.only(bottomLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))                
                ),
                child: Center(child: Text(description, style: const TextStyle(color: Colors.white),),),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}