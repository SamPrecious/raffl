import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/models/user_data_model.dart';
import 'package:raffl/repositorys/listing_repository.dart';

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

  //Construct a list of 3 recommendations relevant to the users interest
  Future<List<ListingModel>> getRecommendations(List<String>? recentlyViewed) async{
    int recommendationsLength = 4; //Modify this as you wish
    print("The recommendations");
    Map<String, dynamic>? currentUserPreferences = await getUserPreferences();
    List<String> blacklist = []; //A blacklist of things we dont want
    if(recentlyViewed != null){
      for(String listing in recentlyViewed){
        blacklist.add(listing); //Recently viewed listings already on home page, so we don't want to see them again
      }
    }
    List<ListingModel> recommendationsList = [];
    final listingRepository = Get.put(ListingRepository());

    if(currentUserPreferences != null){
      Map<String, int>? integerPreferencesMap = currentUserPreferences.map((key, value) => MapEntry(key, value as int));
      //List<String> preferenceArray = [];
      int totalRange = 0;
      for (var entry in integerPreferencesMap.entries) {
        int multiplier = entry.value;
        totalRange += multiplier;
      }

      while(integerPreferencesMap.length > 0 && recommendationsList.length < recommendationsLength){
        print("Total range: ${totalRange}");
        Random random = new Random();
        int randomTagNum = random.nextInt(totalRange);
        print(randomTagNum);
        int currentRange = 0;
        for (var entry in integerPreferencesMap.entries) {
          int multiplier = entry.value;
          currentRange += multiplier;
          print("Cur Range: ${currentRange}");
          if(randomTagNum < currentRange){
            String selectedTag = entry.key;
            print("Our random tag is: ${selectedTag}");
            integerPreferencesMap.remove(selectedTag);
            print("new integerPreferencesMap ${integerPreferencesMap}");
            totalRange -= multiplier;
            //TODO select a random search result with this tag that ISN'T in recentlyViewed AND hasn't been selected yet. Add it to recommendations
            ListingModel? randomListing = await listingRepository.getRecommendedListingByTag(selectedTag, blacklist);
            if(randomListing != null){
              recommendationsList.add(randomListing);
              blacklist.add(randomListing.getDocumentID()); //To avoid re-selecting the same listing
            }
            break;
          }
        }
      }
    }

    print("We have got the recommended listings: ${recommendationsList}");
    while(recommendationsList.length < recommendationsLength){
      ListingModel? randomListing = await listingRepository.getRecommendListingRandom(blacklist);
      if(randomListing != null){
        recommendationsList.add(randomListing);
        blacklist.add(randomListing.getDocumentID()); //To avoid re-selecting the same listing
      }
    }

    print("Final recommended listings: ${recommendationsList}");
    return recommendationsList;
  }

  getUserPreferences() async{
    final snapshot = await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('UserPreferences')) {
      return snapshot.get('UserPreferences');
    }
    return null;
  }

  updateUserPreferences(List<String> tags, int multiplier) async{
    print("To update user preferences:");
    final snapshot = await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic>? currentUserPreferences = await getUserPreferences();


    for(String tag in tags){
      int newValue = multiplier;
      if(currentUserPreferences != null){
        int currentValue = currentUserPreferences[tag] ?? 0;
        newValue += currentValue;
      }

      print("Updating user preferences: ");
      print(tag);
      await db.collection("UserData").doc(user.uid).update({
        'UserPreferences.$tag': newValue
      });
      //await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).update({'RecentlyViewed': newRecentlyViewed});
    }
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
  Future<List<String>?> getRecentlyViewed() async{
    final snapshot = await db.collection("UserData").where(FieldPath.documentId, isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    final recentlyViewed = snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.recentlyViewed;

    return recentlyViewed;
  }




  Future<void> updateRecentlyViewed(String listingID) async{
    final recentlyViewed = await getRecentlyViewed();
    /*
    We want the most recent 2 listings SO:
    IF(item doesnt exist)
      Add item to front of array
      remove last item if >2
    IF item exists
      IF item at front do nothing
      IF item at back, swap order
     */
    if(recentlyViewed != null){
      print("Recently viewed exists");
      List<String> newRecentlyViewed = List.from(recentlyViewed);
      bool arrayChanged = false;
      if(recentlyViewed.length == 2){
        print("Shifting listing");
        if(recentlyViewed.contains(listingID)){
          //Swap order
          if(recentlyViewed[1] == listingID){
            String lastRecentlyViewed = newRecentlyViewed[0];
            newRecentlyViewed[0] = listingID;
            newRecentlyViewed[1] = lastRecentlyViewed;
            arrayChanged = true;
          }
        }else{
          newRecentlyViewed.insert(0, listingID);
          newRecentlyViewed.removeLast();
          arrayChanged = true;
        }
      }else{
        if(!recentlyViewed.contains(listingID)){
          newRecentlyViewed.insert(0, listingID);
          arrayChanged = true;
        }
      }
      print("Old recently viewed: ${recentlyViewed}");
      print("New recently viewed: ${newRecentlyViewed}");

      if(arrayChanged == true){
        //replace collection with new array
        print("Replacing recently viewed");
        await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).update({
          'RecentlyViewed': newRecentlyViewed
        });
      }

    }else{
      print("Error: Recently viewed NULL");
    }
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


  Future<List<String>?> getWatching(String uid) async {
    final snapshot = await db
        .collection("UserData")
        .where(FieldPath.documentId, isEqualTo: uid)
        .get();
    final watching =
        snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.watching;
    print("Ready to return watching");
    return (watching);
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

  Future<String> getNotificationToken(String userID) async{
    final snapshot = await db
        .collection("UserData")
        .where(FieldPath.documentId, isEqualTo: userID)
        .get();
    final notificationToken =
        snapshot.docs.map((e) => UserDataModel.fromFirestore(e)).single.notificationToken;
    return (notificationToken!);
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
