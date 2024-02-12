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

  updateUserData(UserDataModel userData) async{
    await userDataRepository.updateUserData(userData);
  }

  incrementCredits(int newCredits) async{
    await userDataRepository.incrementCredits(newCredits);
  }

}
