
import 'package:productos_app/src/ui/pages/home/home_page.dart';
import 'package:productos_app/src/ui/pages/pages.dart';

class AppRoutes{

    static const String initialRoute= 'checking-auth';
    static Map<String, Widget Function(BuildContext)> routes = {
      
      'login'        : (_) => const LoginPage(),
      'register'     : (_) => const RegisterUser(),
      'home'         : (_) => const HomePage(),
      'checking-auth': (_) => const CheckingAuth(),
      'test'         : (_) => const TestPage(),
      
    };
}