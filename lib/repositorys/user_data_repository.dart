import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';


class UserDataRepository extends GetxController {
  static UserDataRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  createUserData(UserDataModel userData) async{
    //Sets userID to documentID, so we can retrieve documents linked to our users data

    await db.collection("UserData").doc(user.uid).set(userData.toFirestore()).whenComplete(
          () => print("User creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  //TODO
  Future<int> getCredits(String uid) async {
    final snapshot = await db.collection("UserData").where(FieldPath.documentId, isEqualTo: uid).get();
    final userCredits = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.credits;
    return(userCredits);
  }

  Future<UserDataModel> getUserDetails(String uid) async {
    final snapshot = await db.collection("UserData").where(FieldPath.documentId, isEqualTo: uid).get();
    final userData = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single;
    return userData;
  }

  Future<void> updateUserData(UserDataModel userData) async {
    await db.collection("UserData").doc(user.uid).update(userData.toFirestore());
  }

  Future<void> incrementCredits(int newCredits) async {
    //Increments field value by the new credits
    await db.collection("UserData").doc(user.uid).update({"Credits": FieldValue.increment(newCredits)});

  }

}