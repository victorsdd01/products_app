

// ignore_for_file: prefer_final_fields

import 'package:productos_app/src/ui/pages/pages.dart';

class SignUpProvider extends ChangeNotifier{

  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  bool _showPassword  = true;
  bool _autoFocus     = true;
  bool _isEnableEmail = true;
  bool _isEnablePass  = false;
  
  FocusNode emailFnode = FocusNode();
  FocusNode passwordFnode = FocusNode();
  
  String _email    = "";
  String _password = "";

  String get email => _email;
  String get password => _password;

  bool get showPassword => _showPassword;
  bool get autoFocus => _autoFocus;
  bool get isEnableEmail => _isEnableEmail;
  bool get isEnablePass => _isEnablePass;

  set email(String value) {
    _email    = value;
    notifyListeners();
  }
  set password(String value) {
    _password = value;
    notifyListeners();
  }
  set showPassword (bool value) {
    _showPassword = value;
    notifyListeners();
  }

  bool isValidForm(){
    return signUpKey.currentState?.validate() ?? false;
  }


  @override
  void dispose() {
    emailFnode.dispose();
    passwordFnode.dispose();
    super.dispose();
  }
}