import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddressModel {
  final String name;
  final String address;
  final String postcode;
  final String city;


  const AddressModel({
    required this.name,
    required this.address,
    required this.postcode,
    required this.city,
  });

  toFirestore() {
    return {
      "Name": name,
      "Address": address,
      "Postcode": postcode,
      "City": city,
    };
  }

  factory AddressModel.fromFirestore(Map<String, dynamic> address) {
    //SnapshotOptions? options <-Another argument you can add
    return AddressModel(
      name: address['Name'],
      address: address['Address'],
      postcode: address['Postcode'],
      city: address['City'],
    );
  }
  @override
  String toString() {
    return 'AddressModel: {name: $name, address: $address, postcode: $postcode, city: $city}';
  }

  String getName(){
    return name;
  }

  String getAddress(){
    return address;
  }
  String getPostcode(){
    return postcode;
  }
  String getCity(){
    return city;
  }


}


