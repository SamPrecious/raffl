//The home screen for Raffl
import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/controllers/user_data_controller.dart';
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
    final algoliaListingsController = Get.put(AlgoliaListingsController());
    final controller = Get.put(UserDataController());

    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_){
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                  }, suggestionsBuilder: (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      }
                    );
                  });
                  //Handles the suggestions from the search bar
                }),
          ),
          FutureBuilder(
              future: algoliaListingsController.searchListings(""),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done) {
                  if(snapshot.hasData) {
                    List<AlgoliaObjectSnapshot> outputList = snapshot.data as List<AlgoliaObjectSnapshot>;
                    print(outputList);
                    int outputLength = outputList.length;
                    print("output length is $outputLength");
                    return Column(
                      children: [
                        Text("Has Data"),
                      ],
                    );
                  }
                  else{
                    return Column(
                      children: [
                        Text("No Data"),
                      ],
                    );
                  }

                }else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()));
                }else{
                  return Center(child: Text("Error, no data found"));
                }

              }),
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
                      AutoRouter.of(context).push(ProfileRoute());
                    },
                    icon: Icon(Icons.person_rounded, size: 32),
                    label: const Text('Profile'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: standardButton,
                    onPressed: () {
                      //searchListings("test");
                      print("testing");
                    },
                    icon: Icon(Icons.settings, size: 32),
                    label: const Text('Test'),
                  ),
                ],
              ),
            )
          ),

        ],
      ),
      //TODO Abstract the navbar to a seperate widget so it can be called upon by all classes that use it

      bottomNavigationBar: BottomNavigationBar(
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

    );
  }
}
