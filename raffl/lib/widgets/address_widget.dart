import 'package:flutter/material.dart';
import 'package:raffl/models/address_model.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/text_styles.dart';

import 'label_value_pair_widget.dart';

class AddressWidget extends StatelessWidget {
  final AddressModel address;
  final double itemSpacing;

  AddressWidget({required this.address, required this.itemSpacing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // 90% of screen width
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),

      child: DefaultTextStyle(
        style: TextStyle(
          color: primaryColor, // Change this to the color you want.
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        child: IntrinsicWidth(
          child: Column(
            children: [
              LabelValuePairWidget(
                  label: 'Name: ',
                  value: address.getName(),
                  itemSpacing: itemSpacing),
              LabelValuePairWidget(
                  label: 'Address: ',
                  value: address.getAddress(),
                  itemSpacing: itemSpacing),
              LabelValuePairWidget(
                  label: 'Postcode: ',
                  value: address.getPostcode(),
                  itemSpacing: itemSpacing),
              LabelValuePairWidget(
                  label: 'City: ',
                  value: address.getCity(),
                  itemSpacing: itemSpacing),
            ],
          ),
        ),
      ),
    );
  }
}




