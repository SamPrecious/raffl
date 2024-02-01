import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';



class UserDataRepository extends GetxController {
  static UserDataRepository get instance => Get.find(); //Static instance of all getx controllers
  final _db = FirebaseFirestore.instance;

  createUserData(UserDataModel user) async{
    await _db.collection("UserData").add(user.toJson()).whenComplete(
            () => print("User creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });

  }

}