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
  int currentIndex = 0;

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
                currentIndex: currentIndex,
                onTap: (index) {
                  currentIndex = index;
                  setState(() {}); //Rebuilds navbar for current index TODO Make this update when subpages are selected
                  final currentRouteName = AutoRouter.of(context).topRoute.name;
                  switch(index) {
                    case 0:
                      if(currentRouteName != HomeRoute.name){
                        AutoRouter.of(context).push(HomeRoute());
                      }else{ //Refresh page with popAndPush if page already selected
                        AutoRouter.of(context).popAndPush(HomeRoute());
                      }
                      break;
                    case 1:
                      if(currentRouteName != WatchingRoute.name){
                        AutoRouter.of(context).push(WatchingRoute());
                      }else{
                        AutoRouter.of(context).popAndPush(WatchingRoute());
                      }
                      break;
                    case 2:
                      if(currentRouteName != WinsRoute.name){
                        AutoRouter.of(context).push(WinsRoute());
                      }else{
                        AutoRouter.of(context).popAndPush(WinsRoute());
                      }
                      break;
                    case 3:
                      if(currentRouteName != InboxRoute.name){
                        AutoRouter.of(context).push(InboxRoute());
                      }else{
                        AutoRouter.of(context).popAndPush(InboxRoute());
                      }
                      break;
                    case 4:
                      if(currentRouteName != SellingRoute.name){
                        AutoRouter.of(context).push(SellingRoute(ongoing: true));
                      }else{
                        AutoRouter.of(context).popAndPush(SellingRoute(ongoing: true));
                      }
                      break;

                  }
                },
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: currentIndex == 1
                        ? Image.asset('assets/icons/watch_blue.png', width: 24, height: 24)
                        : Image.asset('assets/icons/watch_white.png', width: 24, height: 24),
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
  //Clears bottom navbar content if on unrelated page
  void clearBottomNavbar() {
    setState((){
      currentIndex = -1;
    });
  }
}
