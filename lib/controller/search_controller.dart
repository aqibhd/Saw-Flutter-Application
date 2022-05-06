import 'package:get/get.dart';

class SearchController extends GetxController {
  List photos = [];
  bool isScrollAtEnd = false;
  bool isEmptyList = false;
  bool isGettingPhotos = false;
  bool isLoading = false;

  set updatePhotoList(List value) {
    photos = value;
    update();
  }

  set updateGettingPhotos(bool value) {
    isGettingPhotos = value;
    update();
  }

  set updateIsLoadingValue(bool value) {
    isLoading = value;
    update();
  }

  set addMorePhotosList(List value) {
    if (value.isEmpty) {
      isEmptyList = true;
    }
    photos.addAll(value);
    isScrollAtEnd = false;
    update();
  }

  set updateIsScrollAtEndValue(bool value) {
    isScrollAtEnd = value;
    update();
  }

  set changeIsEmptyList(bool value) {
    isEmptyList = value;
    update();
  }

  void reset() {
    photos = [];
    isScrollAtEnd = false;
    isEmptyList = false;
    isGettingPhotos = false;
    isLoading = false;
  }
}
