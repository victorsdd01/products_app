import 'package:flutter/gestures.dart';
import 'package:productos_app/src/models/models.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/services/auth_service.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';
import 'package:provider/provider.dart';

class RegisterUser extends StatelessWidget {
  const RegisterUser({super.key});

  @override
  Widget build(BuildContext context) {
    final authService =  Provider.of<AuthService>(context);
    final signUpProvider =  Provider.of<SignUpProvider>(context);
    final Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Stack(
        children: [
          const AuthBackground(colors: [
              Color.fromRGBO(63, 63, 153, 1), 
              Color.fromRGBO(90, 70, 178, 1),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
              height: size.height * 0.40,
              width: size.width * 0.90,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Sign up",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      fontSize: 35,
                      color: Colors.blueGrey.shade300
                    ),
                  ),
                  SizedBox(height: size.height * 0.03,),
                  Form(
                    key: signUpProvider.signUpKey,
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: signUpProvider.emailFnode,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.deepPurple.shade700,
                          autofocus: signUpProvider.autoFocus,
                          keyboardType: TextInputType.text,
                          decoration:  InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: signUpProvider.isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400 ),
                            prefixIcon: Icon(Icons.email, color: signUpProvider.isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400,),
                            hintText: 'Email',
                          
                          ),
                          onFieldSubmitted: (value) {
                            signUpProvider.emailFnode.unfocus();
                            FocusScope.of(context).requestFocus(signUpProvider.passwordFnode);
                          },
                          onChanged: (value) => signUpProvider.email = value,
                          validator: (value) {
                             String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                             RegExp regExp  =  RegExp(pattern);
                             return regExp.hasMatch(value ?? '')
                                    ? null
                                    : 'Is not an email';
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: size.height * 0.02,),
                        TextFormField(
                          focusNode: signUpProvider.passwordFnode,
                          cursorColor: Colors.deepPurple.shade700,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.deepPurple.shade700  ),
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.password, color: Colors.deepPurple.shade700),
                            suffixIcon: IconButton(
                              icon:  Icon(
                                signUpProvider.showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                color: !signUpProvider.showPassword ?  Colors.deepPurple.shade700 :  Colors.grey.shade400,
                              ),
                              onPressed: () => signUpProvider.showPassword = !signUpProvider.showPassword,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: signUpProvider.showPassword,
                          obscuringCharacter: '*',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) => signUpProvider.password =  value,
                          validator: (value) {
                              if(value == ''){
                                return 'This field is required';
                              }else{
                                return null ;
                              }
                          },
                        ),
                        SizedBox(height: size.height * 0.02,),
                        CustomButtom(
                          text: !authService.validating ? 'Sign up' : '',
                          textColor: Colors.white, 
                          backgroundColor: Colors.purple.shade900, 
                          borderRadius: 10,
                          child: authService.validating ?  const CircularProgressIndicator.adaptive(backgroundColor: Colors.white,) : null,
                          onClick: () async{
                            final valid = signUpProvider.isValidForm();
                            if(valid){
                              await authService.signUp(
                                NewUser(
                                  email: signUpProvider.email,
                                  password: signUpProvider.password
                                )
                              ).then((value) {
                                switch (value) {
                                  case "EMAIL_EXISTS":
                                    error(context);
                                    break;
                                  default:
                                    success(context);
                                    Future.delayed(const Duration(milliseconds: 803),() => Navigator.pushReplacementNamed(context, "home"));
                                    break;
                                }
                              });
                            }
                          },
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.30,
            right: size.width * 0.20,
            child: RichText(
              text:  TextSpan(
                children: [
                  const TextSpan(text: "have an account? ",style: TextStyle(color: Colors.black87),),
                  TextSpan(
                    text: "sign in",
                    style: TextStyle(
                      color: Colors.blue.shade500), 
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacementNamed(context, "login")),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}

void error(BuildContext context) => ScaffoldMessenger
  .of(context)
  .showSnackBar(
     SnackBar(
        content: const Text('El usuario ya esta registrado'),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(milliseconds: 800),
      )
  );
void success(BuildContext context) => ScaffoldMessenger
  .of(context)
  .showSnackBar(
     SnackBar(
        content: const Text('Usuario agregado correctamente!'),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(milliseconds: 800),
      )
  );