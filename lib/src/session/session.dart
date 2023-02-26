import 'package:productos_app/src/ui/pages/pages.dart';

class SessionPreferences{

  static late SharedPreferences preferences;

  static Future<void> init() async{
    await SharedPreferences.getInstance();
  }
}