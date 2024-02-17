import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';


/*
This dart file contains the primary template for authenticated pages
Includes standards like the NavBar that are used on all pages
 */

@RoutePage()
class AuthenticatedPages extends StatefulWidget {
  const AuthenticatedPages({super.key});

  @override
  State<AuthenticatedPages> createState() => _AuthenticatedPagesState();

}

class _AuthenticatedPagesState extends State<AuthenticatedPages> {
  @override
  Widget build(BuildContext context) {
    //return const AutoRouter();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: const AutoRouter()
            ),
            BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Watching',
                  ),
                ]),
          ],
        )
      )
    );
  }
}