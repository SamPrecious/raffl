import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/inbox_controller.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import 'package:raffl/widgets/inbox_widget.dart';
import 'package:raffl/widgets/title_header_widget.dart';

import '../routes/app_router.gr.dart';

@RoutePage()
class InboxPage extends StatelessWidget {
  final InboxController notificationController;

  InboxPage({Key? key})
      : notificationController = Get.put(InboxController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      TitleHeaderWidget(title: 'Inbox'),
      Expanded(
        child: FutureBuilder(
          future: notificationController.getInboxEntries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<NotificationModel> outputList =
                    snapshot.data as List<NotificationModel>;
                int outputLength = outputList.length;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: outputLength,
                      itemBuilder: (context, index) {
                        NotificationModel notification = outputList[index];
                        String notifID = notification.getNotificationID();
                        String listingID = notification.getListingID();
                        String notifName = notification.getName();
                        String imageUrl = notification.getImageUrl();
                        String notifDesc = notification.getDescription();
                        return GestureDetector(
                          child: InboxWidget(
                            inboxID: notifID,
                            listingID: listingID,
                            inboxName: notifName,
                            imageUrl: imageUrl,
                            inboxDesc: notifDesc,
                          ),
                            onTap: () => AutoRouter.of(context).push(ViewListingRoute(documentID: listingID))

                        );
                      }),
                );
              } else {
                return Column(
                  children: [
                    Text("No Data"),
                  ],
                );
              }
              return (Scaffold());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text("Error, no data found"));
            }
          },
        ),
      ),
    ])));
  }
}
