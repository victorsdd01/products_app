// ignore_for_file: file_names

import 'package:productos_app/src/providers/session_provider.dart';
import 'package:productos_app/src/ui/pages/pages.dart';
import 'package:productos_app/src/widgets/widgtes.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final TextEditingController emailController =  TextEditingController();
  late bool showPassword = true;
  late bool autoFocus = true;
  late bool isEnableEmail = true;
  late bool isEnablePass  = false;
  late FocusNode emailFnode;
  late FocusNode passwordFnode;

  void emailControllerListener(){
    print('email value--> ${emailController.text}');
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() => emailControllerListener());
    emailFnode =  FocusNode();
    passwordFnode =  FocusNode();
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFnode.dispose();
    passwordFnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final SessionProvider sessionProvider =  Provider.of<SessionProvider>(context);

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
           width: widget.size.width,
           height: widget.size.height * 0.40,
           child:Form(
            key: sessionProvider.formKey,
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
                  focusNode: emailFnode,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.deepPurple.shade700,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration:  InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400 ),
                    prefixIcon: Icon(Icons.email, color: isEnableEmail ? Colors.deepPurple.shade700 : Colors.grey.shade400,),
                    hintText: 'Email',
                  
                  ),
                  validator: (value) {
                      if(value == ''){
                        return 'This field is required';
                      }else{
                        return null ;
                      }

                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                // const SizedBox(height: 15,),
                const Spacer(),
                 TextFormField(
                  focusNode: passwordFnode,
                  //enabled: isEnablePass,
                  cursorColor: Colors.deepPurple.shade700,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: isEnablePass ? Colors.deepPurple.shade700 : Colors.grey.shade400 ),
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.password, color: isEnablePass ? Colors.deepPurple.shade700 :  Colors.grey.shade400,),
                    suffixIcon: IconButton(
                      icon:  Icon(
                        showPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                        color: !showPassword ?  Colors.deepPurple.shade700 :  Colors.grey.shade400,
                      ),
                      onPressed: (){
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    )
                  ),
                  //controller: controller,
                  keyboardType: TextInputType.text,
                  obscureText: showPassword,
                  obscuringCharacter: '*',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                      if(value == ''){
                        return 'This field is required';
                      }else{
                        return null ;
                      }
                  },
                  
                ),
                const Spacer(),
                CustomButtom(
                  borderRadius: 10.0,
                  width: 20,
                  height: 50,
                  text: 'Sign in',
                  textColor: Colors.white,
                  backgroundColor: Colors.purple.shade900,
                  onClick: (){
                    
                    emailFnode.unfocus();
                    FocusScope.of(context).requestFocus(passwordFnode);
                    setState(() {
                      autoFocus = !autoFocus;
                      // isEnableEmail= !isEnableEmail;
                      // isEnablePass = !isEnablePass;
                    });
                  }
                )
              ],
             ),
           )
          ),
          const Padding(
            padding:  EdgeInsets.only(top: 15),
            child:  Text("Don't have account? register now"),
          )
        ],
      ),
    );
  }
}