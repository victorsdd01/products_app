
import 'package:flutter/material.dart';
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

}