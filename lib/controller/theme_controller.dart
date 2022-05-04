import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool isDarkMode = true;

  set changeIsDarkMode(bool value) {
    isDarkMode = value;
    update();
  }
}
