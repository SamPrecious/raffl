import 'package:flutter/material.dart';
import 'package:raffl/styles/text_styles.dart';

class OptionalInputWidget extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  OptionalInputWidget(
      {required this.label, this.maxLines = 1, required this.textEditingController, this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: myTextStyles.defaultText,
          ),
        ),
        TextField(
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            controller: textEditingController,
            maxLines: maxLines,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
            keyboardType: textInputType
        ),
      ],
    );
  }
}