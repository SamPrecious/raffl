import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ShippingDetailsModel {
  final String courier;
  final String trackingNumber;


  const ShippingDetailsModel({
    required this.courier,
    required this.trackingNumber,
  });

  toFirestore() {
    return {
      "Courier": courier,
      "TrackingNumber": trackingNumber,
    };
  }

  factory ShippingDetailsModel.fromFirestore(Map<String, dynamic> shippingDetails) {
    //SnapshotOptions? options <-Another argument you can add
    return ShippingDetailsModel(
      courier: shippingDetails['Courier'],
      trackingNumber: shippingDetails['TrackingNumber'],
    );
  }
  @override
  String toString() {
    return 'ShippingDetailsModel: {name: $courier, address: $trackingNumber}';
  }

  String getCourier(){
    return courier;
  }

  String getTrackingNumber(){
    return trackingNumber;
  }



}
