import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/repositorys/inbox_repository.dart';

import '../models/user_data_model.dart';
import '../repositorys/user_data_repository.dart';
import 'package:get/get.dart';

//This handles the notifications repository NOT the notification triggers
class InboxController extends GetxController{

  static InboxController get instance => Get.find();

  final inboxRepository = Get.put(InboxRepository());


  Future<void> createInboxEntry(NotificationModel notification, [String? userID]) async {
    if(userID != null){
      await inboxRepository.createInboxEntry(notification, userID);
    }
    else{
      await inboxRepository.createInboxEntry(notification);
    }
  }

  getInboxEntries(){
    return inboxRepository.getInboxEntries();
  }
}