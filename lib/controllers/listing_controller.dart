import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_data_model.dart';
import '../repositorys/listings_repository.dart';
import 'package:get/get.dart';


class ListingController extends GetxController{

  final listingsRepository = Get.put(ListingsRepository());

  getListing(String documentID){
    return listingsRepository.getListing(documentID);
  }

}