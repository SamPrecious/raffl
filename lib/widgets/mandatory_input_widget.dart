import 'package:flutter/material.dart';
import 'package:raffl/styles/text_styles.dart';

class MandatoryInputWidget extends StatelessWidget {
  final String label;
  final int maxLines;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  MandatoryInputWidget(
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
        TextFormField(
          validator: (value) {
            if(textInputType == TextInputType.text){
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
            } else{
              //If number verify that its a valid, non zero number
              int? number = int.tryParse(value!);
              if (number == null || number <= 0) {
                return 'Please enter a valid number';
              }
            }

            return null;
          },
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