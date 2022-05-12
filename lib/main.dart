import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saw/controller/theme_controller.dart';
import 'package:saw/view/home.dart';
import 'package:saw/widgets/custom_scroll_behavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  runApp(const Saw());
}

class Saw extends StatefulWidget {
  const Saw({Key? key}) : super(key: key);

  @override
  State<Saw> createState() => _SawState();
}

class _SawState extends State<Saw> {
  final ThemeController themeController = Get.put(ThemeController());
  final theme = GetStorage();
  @override
  void initState() {
    super.initState();
    if (theme.read('isDarkMode') != null) {
      themeController.updateIsDarkModeValue = theme.read('isDarkMode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, _) =>
          ScrollConfiguration(behavior: CustomBehavior(), child: _!),
      title: 'Saw',
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
