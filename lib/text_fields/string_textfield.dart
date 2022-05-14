import 'package:flutter/material.dart';

class StringTextField extends StatelessWidget {
  final Function changeText;
  final String placeholder;
  final TextEditingController controller;

  const StringTextField(this.changeText, this.placeholder, this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 2.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              decoration: InputDecoration(
                labelText: placeholder,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                changeText(value.isEmpty ? null : value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
