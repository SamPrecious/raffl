import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:raffl/functions/authentication/access_auth.dart';

class AuthWidget extends StatefulWidget {
  final Function(bool?) onResult; //Acts as callback to say if login/register was successful or not
  final bool login;
  final VoidCallback onClickedSwapState; //If the user clicked the 2nd button (register or login)
  const AuthWidget({Key? key, required this.onResult, required this.login, required this.onClickedSwapState}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}


class _AuthWidgetState extends State<AuthWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //final userHandler = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    var password;
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7, //Makes sure safe area only takes up 70% of screen
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.login ?
                        "Log In":"Register",
                        style: myTextStyles.titleText,
                      ),
                      const SizedBox(height: 40),
                      Align( //Pushes email text to left of container
                        alignment: Alignment.bottomLeft,
                          child: Text(
                              'Email',
                            style: myTextStyles.defaultText,
                          )
                      ),
                      TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                          ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email) //Checks email is valid
                          ? 'Enter a valid email'
                                : null,
                      ),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Password',
                            style: myTextStyles.defaultText,
                          )
                      ),
                      TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                          ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length <= 4
                          ? 'Enter 4 characters minimum'
                        : null
                      ),
                      widget.login ?
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forgot Password?',
                            style: myTextStyles.fadedText,
                          )
                      ):
                      const SizedBox(height: 20),
                      ElevatedButton(onPressed: (){
                        if(widget.login){
                          AccessAuth.loginUser(context, emailController.text.trim(), passwordController.text.trim());
                          widget.onResult.call(true);
                        }
                        else{
                          AccessAuth.registerUser(context, emailController.text.trim(), passwordController.text.trim());
                          widget.onResult.call(true);
                        }
                        //print(emailController.text);
                        },
                        style: standardButton,
                        child: widget.login ? //If Login mode, Login is first button
                        Text('Login') : Text('Register')
                      ),
                      const SizedBox(height: 120),
                      widget.login ?
                      Text(
                        'New?',
                        style: myTextStyles.fadedText,
                      ):
                      Text(
                        'Have an account?',
                        style: myTextStyles.fadedText,
                      ),
                      ElevatedButton(onPressed: (){
                        print(emailController.text);
                        print('${widget.login}');
                        widget.onClickedSwapState(); //Indicates that we clicked to swap state
                        },
                          style: standardButton,
                          child: widget.login ? //If Login mode, Register is second button
                          Text('Register') : Text('Login')
                      )
                    ],
                  ),
              ),
          ),
        )
    );
  }

}




