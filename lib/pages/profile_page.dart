import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/repositorys/user_data_repository.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/widgets/title_header_widget.dart';

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
    User user = FirebaseAuth.instance.currentUser!; //Gets user information
    final controller = Get.put(UserDataController());
    return Scaffold(
        body: SafeArea(
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
                            TitleHeaderWidget(title: 'Profile'),
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
                                  label: Text('Add Credits'),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              style: standardButton,
                              onPressed: () async{
                                await controller.incrementCredits(int.parse(controller.credits.text));
                                //Refreshes page to update it with new credits value
                                /* TODO
                                    popAndPush prevents us to going to the old page with the old credits value
                                    This is good, but we should also not update credits with local values
                                    Change so credits update based on FireStore value
                                    ALSO
                                    Maybe replace the popAndPush method tomorrow to just refresh the widgets
                                    That way we won't have a ghost of the previous screen
                                */
          
                                AutoRouter.of(context).popAndPush(ProfileRoute());
          
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
                            SizedBox(height: 80),
                            ElevatedButton.icon(
                              style: standardButton,
                              onPressed: () async{
                                await FirebaseAuth.instance.signOut();
                                //TODO replaceAll should do the same thing, but seems to cause issues, investigage
                                await AutoRouter.of(context).pushAndPopUntil(
                                  const SplashRoute(),
                                  predicate: (_) => false,
                                );
                              },
                              icon: Icon(Icons.logout, size: 32),
                              label: const Text('Log Out'),
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
                ),
              ),
        )


    );
  }
}
