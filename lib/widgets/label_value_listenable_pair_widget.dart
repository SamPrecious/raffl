import 'package:flutter/material.dart';

class LabelValueListenablePairWidget extends StatelessWidget {
  final String label;
  final ValueNotifier<int> value;
  final double itemSpacing;

  LabelValueListenablePairWidget({required this.label, required this.value, required this.itemSpacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            ValueListenableBuilder(
              valueListenable: value,
              builder: (context, value, child) {
                return Text(value.toString());
              },
            ),
            //Text(ticketsOwned.toString()),
            //controller.getTickets(listing.getDocumentID())
          ],
        ),
        SizedBox(height: itemSpacing),
      ],
    );
  }
}