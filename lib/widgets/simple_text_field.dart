import 'package:flutter/material.dart';
import 'package:saw/utils/simple_colors.dart';

class SimpleTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onSubmitted;
  const SimpleTextField(
      {Key? key,
      required this.textEditingController,
      required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      style: TextStyle(color: SimpleColors.text, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "Search...",
          hintStyle:
              TextStyle(color: SimpleColors.hint, fontWeight: FontWeight.w600)),
      onSubmitted: (value) async {
        onSubmitted(value);
      },
      controller: textEditingController,
    );
  }
}
