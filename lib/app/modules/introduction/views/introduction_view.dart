import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Al-Quran Apps",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Sesibuk itukah kamu sampai lupa membaca Al-Quran?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
                width: 300,
                height: 300,
                child: Lottie.asset('assets/lotties/animasi-quran-girl.json')),
          ),
          SizedBox(
            height: 35,
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(Routes.HOME),
            child: Text(
              "GET STARTED",
              style:
                  TextStyle(color: Get.isDarkMode ? colorPurple : colorWhite),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Get.isDarkMode ? colorWhite : colorPurple,
                fixedSize: Size(150, 40),
                shadowColor: Get.isDarkMode ? colorPurpleSoft : Colors.white,
                elevation: 3.5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          )
        ],
      ),
    ));
  }
}
