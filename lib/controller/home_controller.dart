import 'package:get/get.dart';

class HomeController extends GetxController {
  List? photos;
  bool initLoading = true;

  set updatePhotoList(List value) {
    photos ??= [];
    photos = value;
    update();
  }

  set updateInitLoading(bool value) {
    initLoading = value;
    update();
  }
}
