import 'package:shared_preferences/shared_preferences.dart';

class SessionPreferences{

  static late SharedPreferences preferences;

  static Future<void> init() async{
    await SharedPreferences.getInstance();
  }

  

}