
// ignore_for_file: avoid_returning_null_for_void, use_build_context_synchronously, void_checks

import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/services/auth_service.dart';
import 'package:productos_app/src/services/product_services.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';
import 'package:provider/provider.dart';

enum MenuItems{
  logout("Logout");
  final String item;
  const MenuItems(this.item);
}
class HomePage extends StatelessWidget {
    const HomePage({super.key});
    @override
    Widget build(BuildContext context) {
      final productService = Provider.of<ProductServices>(context);
      final AuthService authService =  Provider.of<AuthService>(context);
      final Size size = MediaQuery.of(context).size;
      return  Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton(
            onSelected: (value) async => value == MenuItems.logout 
            ? await Alerts.logOut(context, authService).then((value) {
              switch (value) {
                case true:
                  Navigator.pushReplacementNamed(context, "login");
                  break;
              }
            })
            : null,
            itemBuilder: (_) => [
                PopupMenuItem<MenuItems>(
                value: MenuItems.logout,
                child: Text(MenuItems.logout.item),
              )
            ]
          ),
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text('Products'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: productService.productListIsEmpty ? null : () => Alerts.deleteAllProducts(context, productService), 
                  icon: Icon(Icons.delete, color: productService.productListIsEmpty ? Colors.grey.shade400 : Colors.white,size: 20,)
                ),

              ],
            )
          ],
        ),
        body: productService.isLoading 
              ? const Center(
                  child: CircularProgressIndicator.adaptive()
                )
              : productService.productListIsEmpty 
              ? const Center(
                  child: Text('No data'),
                )  
              : ListView.builder(
                    itemCount: productService.products.length,
                    itemBuilder: (context, index) {
                      final product =  productService.products[index];
                      return GestureDetector(
                        onTap: () => seeProduct(size, product,context),
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
                            : showSnackBar(context);
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade500,
          onPressed: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0)
                )
              ),
              builder: (context) {
                  final ProductsProvider productsProvider =  Provider.of<ProductsProvider>(context);
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize:0.90,
                    maxChildSize: 0.95,
                    minChildSize: 0.40,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Form(
                          key: productsProvider.productsFormKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async => await productService.putImageFromGallery(),
                                child: Stack(
                                  children:[
                                    (productService.selectedImage) != null 
                                    ? 
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      margin: const EdgeInsets.only(top: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),        
                                      ),
                                      width: size.width *0.90,
                                      height: size.height * 0.30,
                                      child: Image.asset(productService.selectedImage!.path, fit: BoxFit.cover,)
                                    ) 
                                    :
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
                                  textInputAction: TextInputAction.next,
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
                              const SizedBox(height: 20,),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0, right:8.0),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  focusNode: productsProvider.productDescriptionfn,
                                  onChanged: (value) => productsProvider.setProductDescription = value,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Colors.deepPurple.shade400,
                                  decoration: const InputDecoration(
                                    label: Text('Description'),
                                    hintText: 'Write a description',
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
                              CustomButtom(
                                backgroundColor:productsProvider.disableButtom ? Colors.grey.shade300 : Colors.deepPurple.shade400,  
                                textColor: Colors.white,
                                text: 'Save',
                                borderRadius: 10.0,
                                onClick: productsProvider.disableButtom ? null : () async {
                                  final result = productsProvider.validForm();
                                  if(result){
                                    final resp = await productService.addNewProduct(
                                      Products(
                                        name: productsProvider.producName, 
                                        image: (productService.selectedImage?.path) != null ? productService.selectedImage!.path : "no image", 
                                        price: double.parse(productsProvider.producPrice), 
                                        description: productsProvider.productDescription, 
                                        isAvailable: productsProvider.isAvailable
                                      )
                                    );
                                    if(resp){
                                      productsProvider.clearState();
                                      productService.setSelectedImage = null;
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 20,),
                            ],
                          )
                        ),
                      );
                    },
                  );
              }
            );
          },
          child: const Icon(Icons.add)
        ),
      );
    }

    void showSnackBar(BuildContext context){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('No image available',style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.amber,
                                )
                            );
    } 
    void seeProduct(Size size, Products product, BuildContext context) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))),
        context: context, 
        builder: (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.90,
          maxChildSize: 0.95,
          minChildSize: 0.40,
          builder: (context, scrollController) {

            final ProductsProvider productsProvider =  Provider.of<ProductsProvider>(context);
            final ProductServices  productsServices =  Provider.of<ProductServices>(context);

            return SingleChildScrollView(
              controller: scrollController,
              child: Form(
                key: productsProvider.productsFormKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async => await productsServices.getImageFromGallery(product),
                      child: Stack(
                        children:[
                          product.image != 'no image' 
                          ? Stack(
                            children:[
                              Container(
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
                                 child: product.image.contains("/Users") 
                                          ? Image.asset(product.image, fit: BoxFit.cover,) 
                                          : Image.network(product.image, fit: BoxFit.cover),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 0,
                                  child: IconButton(
                                        onPressed: () => Alerts.deleteProductById(context, productsServices, product.id!), 
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                  )
                                )
                            ],
                          ) 
                          : Stack(
                            children: [
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
                                  right: 0,
                                  child: IconButton(
                                        onPressed: () async => await Alerts.deleteProductById(context, productsServices, product.id!).then((value) => value ? Navigator.pop(context): null), 
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                  )
                                )
                              ],
                          ),
                          Positioned(
                            top: 10,
                            left: 0,
                            child: IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.keyboard_arrow_left_outlined,color: Colors.grey.shade500, size: 30,)
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0, right: 8.0),
                      child: TextFormField(
                        initialValue: product.name,
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
                            if(product.name != value){
                              productsProvider.setUpdateBottomDisabled(false);
                            }
                            product.name = value;
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
                        initialValue: product.price.toString(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: productsProvider.productPricefn,
                        onEditingComplete: () {
                          productsProvider.productPricefn.unfocus();
                          FocusScope.of(context).requestFocus(productsProvider.productDescriptionfn);
                        },
                        onChanged: (value) {
                          if(product.name != value){
                            productsProvider.setUpdateBottomDisabled(false);
                          }
                          product.price = value.isNotEmpty ? double.parse(value) : 0.0;
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
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
                        initialValue: product.description,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: productsProvider.productDescriptionfn,
                        onChanged: (value) {
                          if(product.name != value){
                            productsProvider.setUpdateBottomDisabled(false);
                          }
                          product.description = value;
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        cursorColor: Colors.deepPurple.shade400,
                        decoration: const InputDecoration(
                          label: Text('Product description'),
                          hintText: 'Product description',
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
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
                          value: product.isAvailable, 
                          onChanged: (value) {
                            product.isAvailable = value;
                            productsProvider.setIsAvailableSet= value;
                          },                   
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    CustomButtom(
                      backgroundColor:productsProvider.updateBottomDisabled ? Colors.grey.shade300 : Colors.deepPurple.shade400,  
                      textColor: Colors.white,
                      text: 'Update',
                      borderRadius: 10.0,
                      onClick: productsProvider.updateBottomDisabled ? null : () async {
                         if(productsProvider.validForm()){
                           final upated = await productsServices.updateProduct(product);
                           if(upated){
                             Navigator.pop(context);
                             productsServices.setSelectedImage = null;
                           }
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