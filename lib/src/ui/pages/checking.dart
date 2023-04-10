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
            print("no token available");
            Future.microtask(() {
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder:(_, __, ___) => const LoginPage(),
                transitionDuration: Duration.zero
              ));
            });
          }else{
            print("token value:${snapshot.data}");
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

Widget done(AsyncSnapshot<String> snapshot, BuildContext context){
  if(snapshot.hasData){
    switch (snapshot.data) {
      case "no-token":
        print("no tienes token");
        Navigator.of(context).pushReplacementNamed("login");
        break;
      default:
        print("tiene token");
        Navigator.of(context).pushReplacementNamed("home");
        break;
    }
    // hay data
  }else if(!snapshot.hasData){
    //ocurrio un error
    print("ocrrio un error");
  }else{
    print("no hay data");
    // no hay data
  }
  return const SizedBox();
}