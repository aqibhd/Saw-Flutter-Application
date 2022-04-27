import 'package:flutter/material.dart';
import 'package:saw/view/splash.dart';

void main() {
  runApp(const Saw());
}

class Saw extends StatelessWidget {
  const Saw({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Saw',
      home: Splash(),
    );
  }
}
