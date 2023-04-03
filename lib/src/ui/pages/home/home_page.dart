
// ignore_for_file: avoid_returning_null_for_void

import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/services/product_services.dart';
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
      final productService = Provider.of<ProductServices>(context);
      return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text('Products'),
        ),
        body: FutureBuilder<List<Products>>(
          future: productService.loadProducts(),
          builder: (context, AsyncSnapshot<List<Products>> snapshot) {
            if(snapshot.hasData){
              return SafeArea(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product =  snapshot.data![index];
                      return GestureDetector(
                        onTap: () => seeProduct(size, product),
                        onLongPress: () {
                          product.image != 'no image' 
                            ? showDialog(
                                  context: context, 
                                  builder: (context)=> Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Image.network(product.image)
                                )
                              )
                            : showSnackBar();
                        },
                        child: ProductCard(
                          image: product.image, 
                          description: product.description, 
                          isAvailable: product.isAvailable, 
                          price: '\$${product.price}',
                        ),
                      );
                    },
                  ),
              );
            } else if(snapshot.hasError){
              return const Center(
                  child: Text('Something wrong!')
                );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive(),);
            }
          }
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

    void showSnackBar(){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('No image available',style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.amber,
                                )
                            );
    } 
    void seeProduct(Size size, Products products){
      showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))),
        context: context, 
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
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
                          products.image != 'no image' 
                          ? Container(
                             clipBehavior: Clip.antiAlias,
                             margin: const EdgeInsets.only(top: 10.0),
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10.0),
                               boxShadow:const <BoxShadow>[
                                 BoxShadow(color: Colors.white10)
                               ]
                             ),
                             width: size.width *0.90,
                             height: size.height * 0.30,
                             child: Image.network(products.image, fit: BoxFit.cover),
                          ) 
                          : Container(
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
                        initialValue: products.name,
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
                            if(products.name != value){
                              productsProvider.setUpdateBottomDisabled(false);
                            }
                            productsProvider.setProductName = value;
                          }
                        },
                        validator: (value){
                          if(value == ''){
                            WidgetsBinding.instance.addPostFrameCallback((_) => productsProvider.setUpdateBottomDisabled(true));
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
                        initialValue: products.price.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: productsProvider.productPricefn,
                        onChanged: (value) {
                          if(products.name != value){
                            productsProvider.setUpdateBottomDisabled(false);
                          }
                          productsProvider.setProducPrice = value;
                        },
                        //enabled: productsProvider.isEnablePrice,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.deepPurple.shade400,
                        decoration: const InputDecoration(
                          label: Text('Product price'),
                          hintText: 'Product price',
                        ),
                        validator: (value) {
                          if(value == ''){
                            WidgetsBinding.instance.addPostFrameCallback((_) => productsProvider.setUpdateBottomDisabled(true));
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
                        initialValue: products.description,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: productsProvider.productDescriptionfn,
                        onChanged: (value) {
                          if(products.name != value){
                            productsProvider.setUpdateBottomDisabled(false);
                          }
                          productsProvider.setProductDescription = value;
                        },
                        //enabled: productsProvider.isEnablePrice,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        cursorColor: Colors.deepPurple.shade400,
                        decoration: const InputDecoration(
                          label: Text('Product description'),
                          hintText: 'Product description',
                        ),
                        validator: (value) {
                          if(value == ''){
                            WidgetsBinding.instance.addPostFrameCallback((_) => productsProvider.setUpdateBottomDisabled(true));
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
                          value: products.isAvailable, 
                          onChanged: (value) => null,                   
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    CustomButtom(
                      backgroundColor:productsProvider.updateBottomDisabled ? Colors.grey.shade300 : Colors.deepPurple.shade400,  
                      textColor: Colors.white,
                      text: 'Update',
                      borderRadius: 10.0,
                      onClick: productsProvider.updateBottomDisabled ? null : (){
                        final resp = productsProvider.validForm();
                        if(resp) {
                          print('updating...');
                        }
                      }
                    ),
                    const SizedBox(height: 20,),
                  ],
                )
              ),
            );
          },
        )
      );
    }
}