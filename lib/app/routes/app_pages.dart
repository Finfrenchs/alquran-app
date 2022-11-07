import 'package:get/get.dart';

import 'package:alquran/app/modules/detail_juz/bindings/detail_juz_binding.dart';
import 'package:alquran/app/modules/detail_juz/views/detail_juz_view.dart';
import 'package:alquran/app/modules/detail_surah_view/bindings/detail_surah_view_binding.dart';
import 'package:alquran/app/modules/detail_surah_view/views/detail_surah_view_view.dart';
import 'package:alquran/app/modules/home/bindings/home_binding.dart';
import 'package:alquran/app/modules/home/views/home_view.dart';
import 'package:alquran/app/modules/introduction/bindings/introduction_binding.dart';
import 'package:alquran/app/modules/introduction/views/introduction_view.dart';
import 'package:alquran/app/modules/search/bindings/search_binding.dart';
import 'package:alquran/app/modules/search/views/search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INTRODUCTION,
      page: () => IntroductionView(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SURAH_VIEW,
      page: () => DetailSurahViewView(),
      binding: DetailSurahViewBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_JUZ,
      page: () => DetailJuzView(),
      binding: DetailJuzBinding(),
    ),
  ];
}
