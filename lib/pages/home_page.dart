//The home screen for Raffl
import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/controllers/inbox_controller.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/standard_button.dart';
import '../controllers/algolia_listings_controller.dart';
import 'package:get/get.dart';


@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!; //Gets user information

    return Scaffold(
      resizeToAvoidBottomInset: false, //Stops trying to resize when keyboard appears
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(32.0),
              child: SearchBar(
                onSubmitted: (query){
                  AutoRouter.of(context).push(SearchResultsRoute(searchInput: query));
                },
                leading: const Icon(Icons.search),
              ),
          ),
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Text('User: '),
                  Text(user.email!),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: standardButton,
                    onPressed: () {
                      //ProfileRoute
                      //AutoRoute.of(context).pa
                      //clearBottomNavbar();
                      AutoRouter.of(context).push(ProfileRoute());
                    },
                    icon: Icon(Icons.person_rounded, size: 32),
                    label: const Text('Profile'),
                  ),
                  /*
                  UserDataController()).createUserData(userData)
                   */
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: standardButton,
                    onPressed: () {
                      AutoRouter.of(context).push(CreateListingRoute());
                    },
                    icon: Icon(Icons.create, size: 32),
                    label: const Text('Create Listing'),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

}


