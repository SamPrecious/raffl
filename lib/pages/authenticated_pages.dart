import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';

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
            Expanded(child: const AutoRouter()),
            //TODO Change icons to custom icons
            BottomNavigationBar(

                type: BottomNavigationBarType.fixed,
                backgroundColor: secondaryColor,
                selectedItemColor: tertiaryColor,
                unselectedItemColor: primaryColor,
                onTap: (index) {
                  final currentRouteName = AutoRouter.of(context).topRoute.name;
                  switch(index) {
                    case 0:
                      if(currentRouteName != HomeRoute.name){
                        AutoRouter.of(context).push(HomeRoute());
                      }
                      break;
                    case 1:
                      print("watch");
                      break;
                    case 2:
                      print("wins");
                      break;
                    case 3:
                      //AutoRouter.of(context).push(HomeRoute()); TODO inboxroute
                      break;
                    case 4:
                      print("Selling");
                      break;

                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    //TODO Change to custom binoculars icon
                    icon: Icon(Icons.watch_later),
                    label: 'Watching',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star_rounded),
                    label: 'Wins',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.markunread),
                    label: 'Inbox',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sell_rounded),
                    label: 'Selling',
                  ),
                ]),
          ],
        )),
        resizeToAvoidBottomInset:
            false //Stops NavBar redrawing when opening keyboard
        );
  }
}
