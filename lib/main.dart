import 'package:flutter/material.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/routes/routes.dart';
import 'package:productos_app/src/session/session.dart';
import 'package:productos_app/src/ui/themes/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionPreferences.init();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => LoginFormProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      theme: AppTheme.themeData(),
    );
  }
}

