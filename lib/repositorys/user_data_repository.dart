import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';


class UserDataRepository extends GetxController {
  static UserDataRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  createUserData(UserDataModel user) async{
    final userID = user.uid;
    //Sets userID to documentID, so we can retrieve documents linked to our users data
    await db.collection("UserData").doc(userID).set(user.toFirestore()).whenComplete(
          () => print("User creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  //TODO
  Future<int> getCredits(String uid) async {
    final snapshot = await db.collection("UserData").where("UID", isEqualTo: uid).get();
    final userCredits = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.credits;
    return(userCredits);
  }

  Future<UserDataModel> getUserDetails(String uid) async {
    final snapshot = await db.collection("UserData").where("UID", isEqualTo: uid).get();
    final userData = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single;
    return userData;
  }

  Future<void> updateUserData(UserDataModel userData) async {
    print("User ID: " + userData.uid);
    await db.collection("UserData").doc(userData.uid).update(userData.toFirestore());
  }

}