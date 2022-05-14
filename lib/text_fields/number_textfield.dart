import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  final Function changeText;
  final String placeholder;
  final TextEditingController controller;
  final bool isDecimal;

  const NumberTextField(
      this.changeText, this.placeholder, this.controller, this.isDecimal,
      {Key? key})
      : super(key: key);

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
              keyboardType: isDecimal
                  ? const TextInputType.numberWithOptions(
                      decimal: true, signed: false)
                  : TextInputType.number,
              autocorrect: false,
              enableSuggestions: false,
              autofocus: false,
              inputFormatters: <TextInputFormatter>[
                if (isDecimal)
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                if (isDecimal)
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    try {
                      final text = newValue.text;
                      if (text.isNotEmpty) double.parse(text);
                      return newValue;
                    } catch (e) {
                      return oldValue;
                    }
                  }),
                if (!isDecimal)
                  FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                labelText: placeholder,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final i = isDecimal ? double.parse(value) : int.parse(value);
                  changeText(i);
                } else {
                  changeText(null);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
