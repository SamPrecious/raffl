import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raffl/models/user_data_model.dart';


class UserDataRepository extends GetxController {
  static UserDataRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  createUserData(UserDataModel user) async{
    await db.collection("UserData").add(user.toFirestore()).whenComplete(
            () => print("User creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });

  }

  //TODO
  Future<int> getCredits(String uid) async {
    final snapshot = await db.collection("UserData").where("UID", isEqualTo: uid).get();
    final userCredits = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.credits;
    print('User Credits: $userCredits');
    return(userCredits);
  }

  Future<UserDataModel> getUserDetails(String uid) async {
    final snapshot = await db.collection("UserData").where("UID", isEqualTo: uid).get();
    final userData = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single;
    return userData;
  }

}