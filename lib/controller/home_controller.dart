import 'package:get/get.dart';

class HomeController extends GetxController {
  List photos = [];
  bool initLoading = true;
  bool isAtEnd = false;

  set updatePhotoList(List value) {
    photos = value;
    update();
  }

  set addMorePhotosList(List value) {
    photos.addAll(value);
    isAtEnd = false;
    update();
  }

  set updateInitLoading(bool value) {
    initLoading = value;
    update();
  }

  set updateIsAtEnd(bool value) {
    isAtEnd = value;
    update();
  }
}
