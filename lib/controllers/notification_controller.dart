import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:raffl/models/notification_data_model.dart';
import 'package:raffl/repositorys/notification_repository.dart';

import '../models/user_data_model.dart';
import '../repositorys/user_data_repository.dart';
import 'package:get/get.dart';


class NotificationController extends GetxController{

  static NotificationController get instance => Get.find();

  final notificationRepository = Get.put(NotificationRepository());


  Future<void> createNotification(NotificationDataModel notification) async{
    await notificationRepository.createNotification(notification);
  }
}