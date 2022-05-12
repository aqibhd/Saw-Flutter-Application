import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saw/controller/theme_controller.dart';

class SimpleColors {
  static final ThemeController _themeController = Get.find<ThemeController>();
  static Color? _background;
  static Color? _modalBackground;
  static Color? _text;
  static Color? _icon;
  static Color? _hint;

  static Color get background {
    return _background = _themeController.isDarkMode
        ? const Color(0xff040404)
        : const Color(0xffFFFFFF);
  }

  static Color get hint {
    return _hint = _themeController.isDarkMode
        ? const Color(0xff6E6E6E)
        : const Color(0xFFAEAEAE);
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

  static Color get icon {
    return _icon = const Color(0xff7C7C7C);
  }
}
