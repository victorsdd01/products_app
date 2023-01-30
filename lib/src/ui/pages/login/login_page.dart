import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children:   [
          const AuthBackground(
            colors: [
              Color.fromRGBO(63, 63, 153, 1), 
              Color.fromRGBO(90, 70, 178, 1),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: LoginForm(size: size)
          ),
        ],
      ),
    );
  }
}