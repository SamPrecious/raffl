import 'package:auto_route/auto_route.dart';
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
@RoutePage()
class AuthPage extends StatefulWidget {
  final Function(bool?) onResult; //Acts as callback to say if login/register was successful or not
  const AuthPage({super.key, required this.onResult});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return AuthWidget(onResult: widget.onResult, onClickedSwapState: toggleLogin, login: isLogin);
  }

  void toggleLogin(){
    setState(() {
      //Swaps the page to and from login
      isLogin = !isLogin;
    });
  }
}