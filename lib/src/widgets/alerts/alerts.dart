
import 'package:flutter/material.dart';
import 'package:productos_app/src/services/auth_service.dart';
import 'package:productos_app/src/services/product_services.dart';
import 'package:productos_app/src/widgets/widgtes.dart';

class Alerts{

  static Future<void> onClosing(BuildContext context)async {
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Are you sure to cancel?'),
        actions: [
          CustomButtom(
            text: 'cancel',
            borderRadius: 10.0, 
            backgroundColor: Colors.red, 
            textColor: Colors.white,
            onClick: () => Navigator.pop(context),
          ),
          CustomButtom(
            text: 'ok',
            borderRadius: 10.0, 
            backgroundColor: Colors.green.shade400, 
            textColor: Colors.white,
            onClick: (){
              // Navigator.pop(context);
              Navigator.popAndPushNamed(context,'home');
            }
          ),
        ],
      ),
    );
  }
  static Future<void> deleteAllProducts(BuildContext context, ProductServices productServices)async {
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Are you sure do you want to delete all products?'),
        actions: [
          CustomButtom(
            text: 'cancel',
            borderRadius: 10.0, 
            backgroundColor: Colors.red, 
            textColor: Colors.white,
            onClick: () => Navigator.pop(context),
          ),
          CustomButtom(
            text: 'ok',
            borderRadius: 10.0, 
            backgroundColor: Colors.green.shade400, 
            textColor: Colors.white,
            onClick: () async => await productServices.deleteAllProducts().then((_) => Navigator.pop(context))      
          ),
        ],
      ),
    );
  }
  static Future<bool> deleteProductById(BuildContext context, ProductServices productServices, String id) async {
    final result = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Are you sure do you want to delete this product?'),
        actions: [
          CustomButtom(
            text: 'cancel',
            borderRadius: 10.0, 
            backgroundColor: Colors.red, 
            textColor: Colors.white,
            onClick: () => Navigator.pop(context,false),
          ),
          CustomButtom(
            text: 'ok',
            borderRadius: 10.0, 
            backgroundColor: Colors.green.shade400, 
            textColor: Colors.white,
            onClick: () async => await productServices.deleteProduct(id).then((value) => Navigator.pop(context,value))
          ),
        ],
      )
    );
    return result!;
  }

  static Future<bool> logOut(BuildContext context, AuthService authService) async {
    final result = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Are you sure do you want to logout?'),
        actions: [
          CustomButtom(
            text: 'cancel',
            borderRadius: 10.0, 
            backgroundColor: Colors.red, 
            textColor: Colors.white,
            onClick: () => Navigator.pop(context,false),
          ),
          CustomButtom(
            text: 'ok',
            borderRadius: 10.0, 
            backgroundColor: Colors.green.shade400, 
            textColor: Colors.white,
            onClick: () async => await authService.logOut().then((value) => Navigator.pop(context,true))
          ),
        ],
      )
    );
    return result!;
  }

}