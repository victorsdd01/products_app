import 'package:productos_app/src/services/auth_service.dart';
import 'package:productos_app/src/ui/pages/home/home_page.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class CheckingAuth extends StatelessWidget {
  const CheckingAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context, listen: false);
    return  Scaffold(
      body: FutureBuilder<String>(
        future: authService.readToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator.adaptive(),);
          }
          if(snapshot.data == 'no-token'){
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder:(_, __, ___) => const LoginPage(),
                transitionDuration: Duration.zero
              ));
            });
          }else{
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder:(_, __, ___) => const HomePage(),
                transitionDuration: Duration.zero
              ));
            });
          }
          return const SizedBox();
        },
      )
    );
  }
}
