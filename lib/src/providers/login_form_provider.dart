
// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';

class LoginFormProvider extends ChangeNotifier{

   GlobalKey<FormState> formKey =  GlobalKey<FormState>();

    String _email= '';
    String _password = '';
    bool _showPassword = true;
    bool _autoFocus = true;
    bool _isEnableEmail = true;
    bool _isEnablePass  = false;
    FocusNode emailFnode = FocusNode();
    FocusNode passwordFnode = FocusNode();

    String get email => _email;
    String get password => _password;
    bool   get showPassword => _showPassword;
    bool   get autoFocus => _autoFocus;
    bool   get isEnableEmail => _isEnableEmail;
    bool   get isEnablePass => _isEnablePass;

    set email(String value){
      _email = value;
      notifyListeners();
    }
    set password(String value){
      _password = value;
      notifyListeners();
    }
    set showPassword(bool value){
      _showPassword = value;
      notifyListeners();
    }


    bool isValidForm(){
      return formKey.currentState?.validate() ?? false;
    }

    @override
  void dispose() {
    emailFnode.dispose();
    passwordFnode.dispose();
    super.dispose();
  }
}