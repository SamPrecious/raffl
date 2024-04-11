import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/repositorys/user_data_repository.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:raffl/widgets/label_value_listenable_pair_widget.dart';
import 'package:raffl/widgets/label_value_pair_widget.dart';
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
    ValueNotifier<int> credits = ValueNotifier<int>(0);
    final controller = Get.put(UserDataController());

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: DefaultTextStyle(
          style: TextStyle(
            color: secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          child: FutureBuilder(
              future: controller.getUserCredits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  //int userCredits = snapshot.data as int;
                  credits.value = snapshot.data as int;
                  //UserDataModel userData = snapshot.data as UserDataModel;
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        TitleHeaderWidget(title: 'Profile'),
                        FractionallySizedBox(
                          widthFactor: 0.8,
                          child: (Column(
                            children: [
                              SizedBox(height: 80),
                              IconButton(
                                onPressed: () {
                                },
                                icon: Icon(Icons.person_rounded, size: 128),
                                style: circularButton,

                              ),
                              SizedBox(height: 20),

                              LabelValuePairWidget(
                                  label: 'User:',
                                  value: user.email!,
                                  itemSpacing: 3.0),
                              LabelValueListenablePairWidget(
                                  label: 'Credits:',
                                  value: credits,
                                  itemSpacing: 3.0),
                              Text(
                                "1 credit = £1",
                                style: myTextStyles.fadedText,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                style: standardButton,
                                onPressed: () async {
                                  TextEditingController ticketNum =
                                      TextEditingController();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      final inputKey = GlobalKey<FormState>();
                                      return AlertDialog(
                                        title: Center(
                                          child: Text('Add Credits',
                                              style: TextStyle(
                                                color: secondaryColor,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        content: Form(
                                          key: inputKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.3,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  controller: ticketNum,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: secondaryColor,
                                                          width: 3.0,
                                                        ),
                                                      )),
                                                  keyboardType: TextInputType
                                                      .numberWithOptions(
                                                          decimal: false),
                                                  validator: (value) {
                                                    int? number =
                                                        int.tryParse(value!);
                                                    if (number == null ||
                                                        number <= 0) {
                                                      return 'Please enter a valid number of tickets';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Center(
                                            child: ElevatedButton(
                                              child: Text('Buy'),
                                              style: standardButton,
                                              onPressed: () async {
                                                if (inputKey.currentState!
                                                    .validate()) {
                                                  int newCredits =
                                                      int.parse(ticketNum.text);
                                                  await controller
                                                      .incrementCredits(
                                                          newCredits);
                                                  credits.value += newCredits;
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                } else {
                                                  print("ERROR");
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Add Credits'),
                              ),
                              ElevatedButton(
                                style: standardButton,
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  await AutoRouter.of(context).pushAndPopUntil(
                                    const SplashRoute(),
                                    predicate: (_) => false,
                                  );
                                },
                                child: const Text('Log Out'),
                              ),
                              SizedBox(height: 10),
                            ],
                          )),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Center(child: Text("Error, no data found"));
                  }
                }
                //Returns loading bar until data is retrieved
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    ));
  }
}
