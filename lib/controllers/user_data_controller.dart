import 'package:raffl/functions/authentication/access_auth.dart';
import '../models/user_data_model.dart';
import '../repositorys/user_data_repository.dart';
import 'package:get/get.dart';


class UserDataController extends GetxController{

  static UserDataController get instance => Get.find();

  final userDataRepository = Get.put(UserDataRepository());

  Future<void> createUserData(UserDataModel user) async{
    await userDataRepository.createUserData(user);
  }
/*
  getUserData(){
    final uid = userDataRepository
  }
*/
}
