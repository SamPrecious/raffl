import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ListingImageRepository extends GetxController {
  static ListingImageRepository get instance => Get.find();
  //final storage = FirebaseStorage.instance;
  final imageRepositoryRef = FirebaseStorage.instance.ref().child('images');

  uploadImage(XFile file, String fileName) async{
    //Create unique filename for image
    Reference referenceImageToUpload=imageRepositoryRef.child(fileName);


    try {
      await referenceImageToUpload.putFile(
          File(file.path),
          SettableMetadata(contentType: "image/jpeg",)
      );
    }catch(error){
      print(error);
    }
    String imageURL = await referenceImageToUpload.getDownloadURL();
    return imageURL;
  }








}