import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/repositorys/user_data_repository.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';

import '../controllers/user_data_controller.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
//TODO Fetch user from User Data Model and use their UID to make sure it works?
class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!; //Gets user information
    Future<UserDataModel> userData = UserDataRepository().getUserDetails(user.uid);
    //final credits = UserDataRepository().getCredits(user.uid);
    final controller = Get.put(UserDataController());
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: FutureBuilder(
                future: controller.getUserCredits(),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    int userCredits = snapshot.data as int;
                    //UserDataModel userData = snapshot.data as UserDataModel;
                    if(snapshot.hasData){
                      return(Column(
                        children: [
                          //FutureBuilder(future: userData, builder: builder),
                          SizedBox(height: 120),
                          Text('User: ' + user.email!),
                          Text('UID: ' + user.uid),
                          Text('Credits: '+ userCredits.toString()),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: controller.credits,
                              decoration: const InputDecoration(
                                label: Text('0'),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: standardButton,
                            onPressed: () async{
                              //TODO Update user credits
                              final userData = UserDataModel(
                                credits: 10, //TODO change to credits + value in input box
                              );
                              await controller.updateUserData(userData);
                              //Refreshes page to update it with new credits value
                              //TODO Change to replace when credits updating is working
                              AutoRouter.of(context).push(ProfileRoute());

                            },
                            icon: Icon(Icons.credit_card, size: 32),
                            label: const Text('Add Credits'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: standardButton,
                            onPressed: () {
                              AutoRouter.of(context).push(HomeRoute());
                            },
                            icon: Icon(Icons.home, size: 32),
                            label: const Text('Home'),
                          ),
                        ],
                      )
                      );
                    }else if(snapshot.hasError){
                      return Center(child: Text(snapshot.error.toString()));
                    }else{
                      return Center(child: Text("Error, no data found"));
                    }
                  }
                  //Returns loading bar until data is retrieved
                  else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }
                /*
                child: Column(
                  children: [
                    //TODO Add future builder to display credits on page
                    //FutureBuilder(future: userData, builder: builder),
                    SizedBox(height: 120),
                    Text('User: '),
                    Text(user.email!),
                    Text('UID: '),
                    Text(user.uid),
                    Text('Credits: '),
                    Text(credits.toString()),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: standardButton,
                      onPressed: () {
                        AutoRouter.of(context).push(HomeRoute());
                      },
                      icon: Icon(Icons.home, size: 32),
                      label: const Text('Home'),
                    ),
                  ],
                ),*/
              ),
            )
        )

    );
  }
}
