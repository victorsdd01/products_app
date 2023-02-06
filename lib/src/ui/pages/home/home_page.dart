// ignore_for_file: avoid_returning_null_for_void

import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';


class HomePage extends StatelessWidget {
    const HomePage({super.key});
  
    @override
    Widget build(BuildContext context) {

      List<Products> productsList = [
        Products(image: 'no image', price: '50.00', description: 'description', isAvailable: true),
        Products(image: 'https://media.direct.playstation.com/is/image/sierialto/ps5-god-of-war-ragnarok-launch-edition-box-front', price: '80.99', description: 'raganrok', isAvailable: true),
        Products(image: 'https://media.very.ie/i/littlewoodsireland/VAPHM_SQ1_0000000088_NO_COLOR_SLf/playstation-5-hogwarts-legacy.jpg', price: '70.00', description: 'harry potter', isAvailable: true),
        Products(image: 'https://media.very.co.uk/i/very/V32D9_SQ1_0000000099_N_A_SLf/playstation-5-call-of-duty-modern-warfare-ii.jpg', price: '69.99', description: 'mwII', isAvailable: true),
        Products(image: 'no image', price: '10.00', description: 'Rayman', isAvailable: false),
      ];


      return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text('Products'),
        ),
        body: SafeArea(
          child: ListView.builder(
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              final product =  productsList[index];
              return GestureDetector(
                onLongPress: () {
                  if(product.image != 'no image'){
                      showDialog(
                      context: context, 
                      builder: (context)=> Dialog(
                          child: Image.network(product.image)
                        )
                      );
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No image available',style: TextStyle(color: Colors.white),),
                        backgroundColor: Colors.amber,
                        )
                    );
                  }
                },
                child: ProductCard(
                  image: product.image, 
                  description: product.description, 
                  isAvailable: product.isAvailable, 
                  price: product.price,
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade500,
          child: const Icon(Icons.add),
          onPressed: () => null
        ),
      );
    }
  
  }