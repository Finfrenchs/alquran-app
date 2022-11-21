import 'package:flutter/material.dart';

const colorGreen = Color(0xff388e3c);
const colorGreenLight = Color(0xff6abf69);
const colorGreenDark = Color(0xff00600f);
const colorBlack = Color(0xff010313);
const colorWhite = Color(0xffFAF8FC);
const colorGreenSoft = Color(0xffBDF1BC);
const colorOrange = Color(0xffE6704A);

ThemeData themeLight = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: colorGreenDark),
    primaryColor: colorGreen,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(elevation: 4, backgroundColor: colorGreen),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: colorGreenDark),
      bodyText2: TextStyle(color: colorGreenDark),
    ),
    listTileTheme: ListTileThemeData(
      textColor: colorGreenDark,
    ),
    tabBarTheme: TabBarTheme(
        labelColor: colorGreenDark,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorGreenDark)))));

ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: colorWhite),
    primaryColor: colorGreenSoft,
    scaffoldBackgroundColor: colorGreenDark,
    appBarTheme: AppBarTheme(elevation: 0, backgroundColor: colorGreenDark),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: colorWhite),
      bodyText2: TextStyle(color: colorWhite),
    ),
    listTileTheme:
        ListTileThemeData(textColor: colorWhite), //using for change theme
    tabBarTheme: TabBarTheme(
        labelColor: colorWhite,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorWhite)))));
