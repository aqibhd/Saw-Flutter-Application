import 'package:get/get.dart';

class PhotoController extends GetxController {
  bool isSettingWallpaper = false;
  bool isInPreviewMode = false;

  set changeIsSettingWallpaper(bool value) {
    isSettingWallpaper = value;

    update();
  }

  set changeIsInPreviewMode(bool value) {
    isInPreviewMode = value;
    update();
  }
}
