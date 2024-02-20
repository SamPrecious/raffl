import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../controllers/listing_controller.dart';
import 'package:get/get.dart';

import '../models/listing_model.dart';


@RoutePage()
class ViewListingPage extends StatefulWidget {
  final String documentID;
  const ViewListingPage({super.key, required this.documentID});

  @override
  State<ViewListingPage> createState() => _ViewListingPageState();
}


//widget.documentID
class _ViewListingPageState extends State<ViewListingPage> {
  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ListingController());
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: controller.getListing(widget.documentID),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                ListingModel listing = snapshot.data as ListingModel;
                //UserDataModel userData = snapshot.data as UserDataModel;
                if(snapshot.hasData){
                  return(Column(
                    children: [
                      //FutureBuilder(future: userData, builder: builder),
                      SizedBox(height: 120),
                      Text('Listing Details: '+ listing.toString()),
                      SizedBox(height: 10),
                      Text('Tags: '+ listing.getTags().toString()),

                    ],
                  )
                  );
                }else if(snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()));
                }else{
                  return Center(child: Text("Error, no data found"));
                }
              }
              //Returns loading bar until data is retrieved
              else{
                return const Center(child: CircularProgressIndicator());
              }
            }
        ),
      ),
    );
  }
}
