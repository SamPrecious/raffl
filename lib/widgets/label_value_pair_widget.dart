import 'package:flutter/material.dart';

class LabelValuePairWidget extends StatelessWidget {
  final String label;
  final String value;
  final double itemSpacing;

  LabelValuePairWidget({required this.label, required this.value, required this.itemSpacing});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value),
          ],
        ),
        SizedBox(height: itemSpacing),
      ],
    );
  }
}