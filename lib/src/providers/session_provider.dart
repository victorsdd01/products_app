

import 'package:productos_app/src/ui/pages/pages.dart';

class SessionProvider extends ChangeNotifier{

  GlobalKey<FormState> formKey =  GlobalKey<FormState>();

  String email= '';
  String password = '';

  bool isValidForm(){
    return true;
  }

}