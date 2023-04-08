
import 'package:productos_app/src/ui/pages/home/home_page.dart';
import 'package:productos_app/src/ui/pages/pages.dart';

class AppRoutes{

    static const String initialRoute= 'home';
    static Map<String, Widget Function(BuildContext)> routes = {
      
      'login' : (context) => const LoginPage(),
      'home'  : (context) => const HomePage(),
      'test'  : (context) => const TestPage(),
      
    };
}