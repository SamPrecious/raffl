import 'package:flutter/material.dart';
import 'package:raffl/widgets/auth_widget.dart';
//TODO put logo on this page?


/*
Auth page handles all things authentication including:
- Login
- Register
- Forgot password
- Verify email
 */
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLogin = true;


  @override
  Widget build(BuildContext context) {
    //Calls the

    return AuthWidget(onClickedSwapState: toggleLogin, login: isLogin);
  }

  void toggleLogin(){
    setState(() {
      //Swaps the page to and from login
      isLogin = !isLogin;
    });
  }
}