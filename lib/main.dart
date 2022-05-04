import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saw/controller/theme_controller.dart';
import 'package:saw/view/home.dart';

void main() {
  runApp(Saw());
}

class Saw extends StatelessWidget {
  Saw({Key? key}) : super(key: key);
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Saw',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
