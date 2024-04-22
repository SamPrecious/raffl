import 'package:firebase_auth/firebase_auth.dart';
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var password;
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7, //Makes sure safe area only takes up 70% of screen
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/icons/raffl_logo_slanted.png'),
                        SizedBox(height: 30),
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
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),            filled: true,
                              fillColor: Colors.grey.shade300,
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
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),            filled: true,
                              fillColor: Colors.grey.shade300,
                            ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                              if(!widget.login){
                                if (value == null || value.length < 8) {
                                  return 'Enter 8 characters minimum';
                                  //The rest uses RegEx to verify certain criteria
                                } else if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                                  return 'Must contain 1 uppercase character';
                                } else if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
                                  return 'Must contain 1 lowercase character';
                                } else if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
                                  return 'Must contain 1 number';
                                } else if (!RegExp(r'^(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
                                  return 'Must contain 1 special character';
                                }
                              }

                            return null;
                          }
                        ),
                        widget.login ?
                        GestureDetector(
                          onTap: () async{
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reset link sent to Email'),
                              ),
                            );
                          },
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Forgot Password?',
                                style: myTextStyles.fadedText,
                              )
                          ),
                        ):
                        const SizedBox(height: 20),
                        ElevatedButton(onPressed: () async {
                          if(widget.login){
                            bool isLoggedIn = await AccessAuth.loginUser(context, emailController.text.trim(), passwordController.text.trim());
                            widget.onResult.call(isLoggedIn);
                          }
                          else if(formKey.currentState?.validate() ?? false){

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
          ),
        ),
        resizeToAvoidBottomInset: false
    );
  }

}




