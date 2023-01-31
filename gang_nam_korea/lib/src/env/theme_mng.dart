import 'package:flutter/material.dart';

class AppColor {
  static const LoginColors login = LoginColors();

  static const background = Color(0xFFEEEEEE);
  static const backgroundWhite = Color(0xFFFFFFFF);
  static const iconWhite = Color(0xFFF0F0F0);
  static const iconBlack = Color(0xFF202020);
  static const textWhite = Color(0xFFF0F0F0);
  static const textBlack = Color(0xFF202020);
  static const textMenuBlack = Color(0xFF606060);
  static const errorBackgroundRed = Color(0xFFEE0000);
  static const shadowColor = Color(0xAA000000);
  static const tabBarIndicatorColor = Color(0xCCFFFFFF);

  static const transparent = Color(0x00FFFFFF);
  static const white = Color(0xFFFFFFFF);
  static const red = Color(0xFFFF0000);
  static const green = Color(0xFF00BB00);
  static const blue = Color.fromARGB(255, 27, 95, 230);
  static const yellow = Color(0xFFDDDD00);
}

class LoginColors {
  const LoginColors();
  final background = const Color(0xFFECF3F9);
  final textColor = const Color(0XFFA7BCC7);
  final iconColor = const Color(0xFFB6C7D1);
  final activeColor = const Color(0xFF09126C);
  final facebookColor = const Color(0xFF3B5999);
  final googleColor = const Color(0xFFDE4B39);
  final orange = const Color(0xFFFF9900);
  final red = const Color(0xFFFF0000);
}

class ThemeMng {
  static final ThemeData defaultTheme = ThemeData();
}
