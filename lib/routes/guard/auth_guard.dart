
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../app_router.gr.dart';


//TODO Moving authorisation checks to guard means load wheels no longer work, fix this
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async{ //TODO awaits for async
    print("Testing current user");
    //await FirebaseAuth.instance.signOut();

    //If user logged in, allow guarded route
    if(FirebaseAuth.instance.currentUser != null){
      print("Already logged in");
      final curUser = FirebaseAuth.instance.currentUser;
      print(curUser);
      resolver.next(true);
    }
    //If user NOT logged in, push AuthRoute and check for log ins
    else{
      //Do this if we are on log  in page and IF we are NOT logged in
      print("Attempting authorisation");
      router.push(AuthRoute(onResult: (result) {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user != null) { //User is authenticated
            // If the user is not logged in, redirect to the AuthPage
            print("Authenticated");
            resolver.next(true);  //Allows access to protected route
            router.removeLast();
          }

        });
      }));
    }
  }
}



//Within Onnavigation
/*
    // Listen to the authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) { //User is authenticated
        // If the user is not logged in, redirect to the AuthPage
        print("Authenticated");
        resolver.next(true);  //Allows access to protected route

      } else {//User is NOT authenticated
        print("Not authenticated");
        resolver.redirect(AuthRoute(onResult: (success){
          if(success == true){
            resolver.next(true);
            router.removeLast();
          }
        }));
      }
    });*/
