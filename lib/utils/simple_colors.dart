import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saw/controller/theme_controller.dart';

class SimpleColors {
  static final ThemeController _themeController = Get.find<ThemeController>();
  static Color? _background;
  static Color? _modalBackground;
  static Color? _text;

  static Color get background {
    return _background = _themeController.isDarkMode
        ? const Color(0xff040404)
        : const Color(0xffFFFFFF);
  }

  static Color get text {
    return _text = _themeController.isDarkMode
        ? const Color(0xffffffff)
        : const Color(0xff000000);
  }

  static Color get modalBackground {
    return _modalBackground = _themeController.isDarkMode
        ? const Color(0xff0F0F0F)
        : const Color(0xffFFFFFF);
  }
}
