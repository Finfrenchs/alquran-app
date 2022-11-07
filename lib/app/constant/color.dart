import 'package:flutter/material.dart';

const colorPurple = Color(0xff431AA1);
const colorPurpleLight = Color(0xff9345F2);
const colorPurpleDark = Color(0xff1E0771);
const colorBlack = Color(0xff010313);
const colorWhite = Color(0xffFAF8FC);
const colorPurpleSoft = Color(0xffB9A2D8);
const colorOrange = Color(0xffE6704A);

ThemeData themeLight = ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: colorPurpleDark),
    primaryColor: colorPurple,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(elevation: 4, backgroundColor: colorPurple),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: colorPurpleDark),
      bodyText2: TextStyle(color: colorPurpleDark),
    ),
    listTileTheme: ListTileThemeData(
      textColor: colorPurpleDark,
    ),
    tabBarTheme: TabBarTheme(
        labelColor: colorPurpleDark,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        unselectedLabelColor: Colors.grey,
        indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorPurpleDark)))));

ThemeData themeDark = ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: colorWhite),
    primaryColor: colorPurpleSoft,
    scaffoldBackgroundColor: colorPurpleDark,
    appBarTheme: AppBarTheme(elevation: 0, backgroundColor: colorPurpleDark),
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
