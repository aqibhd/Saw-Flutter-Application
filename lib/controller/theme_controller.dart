import 'package:get/get.dart';

class ThemeController extends GetxController {
  bool isDarkMode = true;
  bool isPhotoOpened = false;
  set updateIsDarkModeValue(bool value) {
    isDarkMode = value;
    update();
  }

  set updateIsPhotoOpenedValue(bool value) {
    isPhotoOpened = value;
    update();
  }
}
