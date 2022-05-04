import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saw/controller/photo_controller.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

String code(String code) {
  //function to convert to hex-code to int
  return '0xff' + code.substring(1);
}

Future<void> setAsWallpaper(BuildContext context,
    {required String fileName,
    required ScreenshotController controller}) async {
  final PhotoController photoController = Get.find<PhotoController>();
  photoController.changeIsSettingWallpaper = true;
  String _fileName = fileName;
  bool _result = false;
  if (_fileName.isEmpty || _fileName == " ") {
    _fileName = "undefined";
  }
  int location = WallpaperManager
      .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
  final directory = (await getApplicationDocumentsDirectory())
      .path; //from path_provide package
  String path = directory;
  await controller.captureAndSave(
      path, //set path where screenshot will be saved
      fileName: _fileName);
  String newPath = path + "/$_fileName";
  _result = await WallpaperManager.setWallpaperFromFile(newPath, location);

  if (_result) {
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(const SnackBar(content: Text("Wallpaper set")));
  } else {}
}

Future<void> reportBugs() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'dev.aqibh@gmail.com',
    query: 'subject=SAW Bug Report&body=Describe the bug here...',
  );

  if (!await launchUrl(params)) throw 'Could not launch $params';
}

Future<void> launchInstagram() async {
  final Uri params =
      Uri(scheme: 'https', host: 'www.instagram.com', path: 'dev.aqibh/');
  final bool nativeAppLaunchSucceeded = await launchUrl(
    params,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(
      params,
      mode: LaunchMode.inAppWebView,
    );
  }
}
