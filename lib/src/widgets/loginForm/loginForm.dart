// ignore_for_file: file_names, dead_code
import 'package:flutter/gestures.dart';
import 'package:productos_app/src/models/user.dart';
import 'package:productos_app/src/providers/providers.dart';
import 'package:productos_app/src/services/auth_service.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {

    final LoginFormProvider loginFormProvider =  Provider.of<LoginFormProvider>(context);
    final AuthService authService = Provider.of<AuthService>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0)
            ),
           margin: const  EdgeInsets.only(left:10.0, right: 10.0),
           width: size.width,
           height: size.height * 0.40,
           child:Form(
            key: loginFormProvider.formKey,
             child: Column(
              children: <Widget>[
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w300,
                    fontSize: 35,
                    color: Colors.blueGrey.shade300
                  ),
                ),
                const Spacer(),
                TextFormField(
                  //enabled: isEnableEmail,
                  focusNode: loginFormProvider.emailFnode,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.deepPurple.shade700,
                  autofocus: loginFormProvider.autoFocus,
                  keyboardType: TextInputType.text,
                  decoration:  InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: loginFormProvider.isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400 ),
                    prefixIcon: Icon(Icons.email, color: loginFormProvider.isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400,),
                    hintText: 'Email',
                    errorText: authService.validEmail ? null : 'Incorrect email',
                  ),
                  onFieldSubmitted: (value) {
                    loginFormProvider.emailFnode.unfocus();
                    FocusScope.of(context).requestFocus(loginFormProvider.passwordFnode);
                  },
                  onChanged: (value) {
                    loginFormProvider.email = value;
                    if(!authService.validEmail) authService.validEmail = true;
                  },
                  validator: (value) {
                     String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                     RegExp regExp  =  RegExp(pattern);
                     return regExp.hasMatch(value ?? '')
                            ? null
                            : 'Is not an email';
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                const Spacer(),
                 TextFormField(
                  focusNode: loginFormProvider.passwordFnode,
                  cursorColor: Colors.deepPurple.shade700,
                  decoration: InputDecoration(
                    errorText: authService.validPassword ? null : 'Incorrect password',
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.deepPurple.shade700  ),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.password, color: Colors.deepPurple.shade700),
                    suffixIcon: IconButton(
                      icon:  Icon(
                        loginFormProvider.showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                        color: !loginFormProvider.showPassword ?  Colors.deepPurple.shade700 :  Colors.grey.shade400,
                      ),
                      onPressed: () => loginFormProvider.showPassword = !loginFormProvider.showPassword,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: loginFormProvider.showPassword,
                  obscuringCharacter: '*',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    loginFormProvider.password =  value;
                    if(!authService.validPassword) authService.validPassword = true;
                  },
                  validator: (value) {
                      if(value == ''){
                        return 'This field is required';
                      }else if (value!.length <= 5){
                        return 'Min: 6 characters' ;
                      }else{
                        return null;
                      }
                  },
                  
                ),
                const Spacer(),
                CustomButtom(
                  borderRadius: 10.0,
                  width: 20,
                  height: 50,
                  text: !authService.validating ? 'Sign in' : '',
                  textColor: Colors.white,
                  backgroundColor: Colors.purple.shade900,
                  onClick: authService.validating ? null : () async {
                    loginFormProvider.emailFnode.unfocus();
                    FocusScope.of(context).requestFocus(loginFormProvider.passwordFnode);
                    FocusScope.of(context).unfocus();
                    final valid = loginFormProvider.isValidForm();
                    if(valid){
                      await authService.signIn(User(email: loginFormProvider.email, password:loginFormProvider.password)).then((value) {
                        switch (value) {
                          case "EMAIL_NOT_FOUND":
                            authService.validEmail = false;
                            break;
                          case "INVALID_PASSWORD":
                          authService.validPassword = false;
                            break;
                          case "true":
                          Navigator.pushReplacementNamed(context, "home");
                        }
                      });
                    }
                  },
                  child: authService.validating ? const CircularProgressIndicator.adaptive() : null
                )
              ],
             ),
           )
          ),
           Padding(
            padding:  const EdgeInsets.only(top: 15),
            child:  RichText(
              text:  TextSpan(
                children: [
                  TextSpan(text: "Don't have an account? ",style: TextStyle(color: Colors.grey.shade500)),
                  TextSpan(
                    text: "Register now", 
                    style: TextStyle(
                      color: Colors.blue.shade600,), 
                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushReplacementNamed(context, "register")
                    ),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }
}