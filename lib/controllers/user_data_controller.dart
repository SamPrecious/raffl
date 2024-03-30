import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_data_model.dart';
import '../repositorys/user_data_repository.dart';
import 'package:get/get.dart';


class UserDataController extends GetxController{

  static UserDataController get instance => Get.find();

  final credits = TextEditingController();

  final userDataRepository = Get.put(UserDataRepository());

  Future<void> createUserData(UserDataModel user) async{
    await userDataRepository.createUserData(user);
  }

  getUserData(){
    final uid = FirebaseAuth.instance.currentUser!.uid; //Gets user information
    //Fetches user details based on uid
    return userDataRepository.getUserDetails(uid);
  }

  getUserCredits(){
    final uid = FirebaseAuth.instance.currentUser!.uid; //Gets user information
    //Fetches user details based on uid
    return userDataRepository.getCredits(uid);
  }

  updateNotificationToken(String notificationToken) async{
    return await userDataRepository.updateNotificationToken(notificationToken);
  }

  addOrRemoveWatch(String listingID) async{
    bool userIsWatching = await userDataRepository.addOrRemoveWatch(listingID);
    return userIsWatching;
  }

  isUserWatching(String listingID) async{
    bool userIsWatching = false;
    int isUserWatching = await userDataRepository.isUserWatching(listingID);
    if(isUserWatching == 1){
      userIsWatching = true;
    }
    return userIsWatching;
  }

  incrementCredits(int newCredits) async{
    await userDataRepository.incrementCredits(newCredits);
  }

}
