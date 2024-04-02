import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/models/user_data_model.dart';

class UserDataRepository extends GetxController {
  static UserDataRepository get instance =>
      Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  /* TODO
       Make the user accessible from the UserDataRepository rather than redefinining it in all classes
       If not, nullify user if signed out
  */
  User user = FirebaseAuth.instance.currentUser!;



  createUserData(UserDataModel userData) async {
    //Sets userID to documentID, so we can retrieve documents linked to our users data
    user = FirebaseAuth.instance.currentUser!;
    DocumentReference userDataDocument =
        db.collection("UserData").doc(user.uid);
    await userDataDocument
        .set(userData.toFirestore())
        .whenComplete(
          () => print("User creation successful"),
        )
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  addOrRemoveWatch(String listingID) async {
    user = FirebaseAuth.instance.currentUser!;

    int userIsWatching = await isUserWatching(listingID);
    bool userIsWatchingBool = false;

    if (userIsWatching == 1) {
      await db.collection("UserData").doc(user.uid).update({
        "Watching": FieldValue.arrayRemove([listingID])
      });
    } else if (userIsWatching == 0) {
      await db.collection("UserData").doc(user.uid).update({
        "Watching": FieldValue.arrayUnion([listingID])
      });
      userIsWatchingBool = true;
    } else {
      //If the user is not watching ANYONE
      userIsWatchingBool = true;
      await db.collection("UserData").doc(user.uid).set({
        "Watching": FieldValue.arrayUnion([listingID])
      }, SetOptions(merge: true));
    }
    return userIsWatchingBool;
  }

  isUserWatching(String listingID) async {
    DocumentSnapshot userDoc =
        await db.collection("UserData").doc(user.uid).get();
    if (userDoc.exists) {
      var data = userDoc.data();
      if (data is Map<String, dynamic>) {

        if (!data.containsKey('Watching')) {
          return 2;
        } else {
          List<dynamic> watching = userDoc.get('Watching');
          if (watching.contains(listingID)) {
            return 1;
          }
          return 0;
        }
      }
    }
    return 2;
  }

  //Notifications are a subcollection within userData
  createNotification(NotificationModel notificationData) async {
    user = FirebaseAuth.instance.currentUser!;
    await db
        .collection("UserData")
        .doc(user.uid)
        .collection("Notifications")
        .doc(notificationData.getId())
        .set(notificationData.toFirestore())
        .whenComplete(
          () => print("Notification created"),
        )
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  Future<int> getCredits(String uid) async {
    final snapshot = await db
        .collection("UserData")
        .where(FieldPath.documentId, isEqualTo: uid)
        .get();
    final userCredits =
        snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.credits;
    return (userCredits);
  }

  Future<UserDataModel> getUserDetails(String uid) async {
    final snapshot = await db
        .collection("UserData")
        .where(FieldPath.documentId, isEqualTo: uid)
        .get();
    final userData =
        snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single;
    return userData;
  }

  /*
  Future<void> updateUserData(UserDataModel userData) async {
    await db.collection("UserData").doc(user.uid)
        .update(userData.toFirestore());
  }*/
  Future<void> updateNotificationToken(String notificationToken) async {
    //user = FirebaseAuth.instance.currentUser!; //We have just signed in/registered so make sure uid matches
    user = FirebaseAuth.instance.currentUser!;
    await db
        .collection("UserData")
        .doc(user.uid)
        .update({"NotificationToken": notificationToken});
  }

  Future<void> incrementCredits(int newCredits) async {
    //Increments field value by the new credits
    user = FirebaseAuth.instance.currentUser!;
    await db
        .collection("UserData")
        .doc(user.uid)
        .update({"Credits": FieldValue.increment(newCredits)});
  }
  Future<void> awardCredits(String userID, int newCredits) async {
    //Increments field value by the new credits
    await db
        .collection("UserData")
        .doc(userID)
        .update({"Credits": FieldValue.increment(newCredits)});
  }
  Future<bool> subtractCredits(Transaction transaction, int cost) async {
    user = FirebaseAuth.instance.currentUser!;

    final userDoc = FirebaseFirestore.instance.collection("UserData").doc(user.uid);
    DocumentSnapshot userSnapshot = await transaction.get(userDoc);
    Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
    int currentCredits = data["Credits"] ?? 0;
    if(currentCredits - cost >= 0){
      //if user can afford it, do this
      print("Subtracting funds by ${-cost}");
      await transaction.update(userDoc, {"Credits": FieldValue.increment(-cost)});
      return true;
    }
    return false;

  }
}
