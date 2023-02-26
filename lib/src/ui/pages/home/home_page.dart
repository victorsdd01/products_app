
import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
    const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


    @override
    Widget build(BuildContext context) {

      final Size size = MediaQuery.of(context).size;

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
          onPressed: (){

            showModalBottomSheet(
              enableDrag: true,
              isScrollControlled: true,
              useSafeArea: true,
              isDismissible: false,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))),
              context: context, 
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.80,
                maxChildSize: 1,
                minChildSize: 0.40,
                builder: (context, scrollController) {
                
                  final ProductsProvider productsProvider =  Provider.of<ProductsProvider>(context);
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Form(
                      key: productsProvider.productsFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print('open gallery...');
                            },
                            child: Stack(
                              children:[
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  margin: const EdgeInsets.only(top: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:  Colors.grey.shade500,
                                    
                                  ),
                                  width: size.width *0.90,
                                  height: size.height * 0.30,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.photo, color: Colors.grey.shade300,size: 60.0,),
                                        Text('Select photo', style: TextStyle(color: Colors.grey.shade300),)
                                      ],
                                    ),
                                  )
                                ),
                                Positioned(
                                  top: 10,
                                  left: 0,
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      if(productsProvider.getProductName.isNotEmpty && productsProvider.getProductPrice.isNotEmpty){
                                        Alerts.onClosing(context);
                                      } else{
                                          Navigator.of(context).pop();
                                        }
                                    }, 
                                    icon: const Icon(Icons.keyboard_arrow_left_outlined,color: Colors.white, size: 30,)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right: 8.0),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              focusNode: productsProvider.productNamefn,
                              autofocus: productsProvider.autoFocusProducName,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.deepPurple.shade400,
                              decoration: const InputDecoration(
                                label: Text('Product name'),
                                hintText: 'Product name',
                              ),
                              onEditingComplete: () {
                                productsProvider.setIsEnablePrice = true;
                                productsProvider.productNamefn.unfocus();
                                FocusScope.of(context).requestFocus(productsProvider.productPricefn);
                              },
                              onChanged: (value) {
                                if(value.isNotEmpty){
                                  productsProvider.setProductName = value;
                                }
                              },
                              validator: (value){
                                if(value == ''){
                                  return 'This field is required';
                                }else{
                                  return null ;
                                }
                              },
                              
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0, right:8.0),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              focusNode: productsProvider.productPricefn,
                              onChanged: (value) => productsProvider.setProducPrice = value,
                              //enabled: productsProvider.isEnablePrice,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.deepPurple.shade400,
                              decoration: const InputDecoration(
                                label: Text('Product price'),
                                hintText: 'Product price',
                              ),
                              validator: (value) {
                                if(value == ''){
                                  return 'This field is required';
                                }else{
                                  return null ;
                                }
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text('Available'),
                              Switch.adaptive(
                                value: productsProvider.isAvailable, 
                                onChanged: (value) {
                                  productsProvider.setIsAvailableSet = value;
                                }                   
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          CustomButtom(
                            backgroundColor:productsProvider.disableButtom ? Colors.grey.shade300 : Colors.deepPurple.shade400,  
                            textColor: Colors.white,
                            text: 'Save',
                            borderRadius: 10.0,
                            onClick: productsProvider.disableButtom ? null : () {
                              print('name:${productsProvider.producName}');
                              print('price:${productsProvider.producPrice}');
                              print('available:${productsProvider.isAvailable}');
                              final result = productsProvider.validForm();
                              if(result){
                                productsProvider.clearState();
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const SizedBox(height: 20,),
                        ],
                      )
                    ),
                  );
                },
              )
            );
          },
          child: const Icon(Icons.add)
        ),
      );
    }
}