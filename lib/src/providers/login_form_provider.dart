
import 'package:flutter/cupertino.dart';

class LoginFormProvider extends ChangeNotifier{

   GlobalKey<FormState> formKey =  GlobalKey<FormState>();

    String email= '';
    String password = '';

    bool isValidForm(){
      return formKey.currentState?.validate() ?? false;
    }

}