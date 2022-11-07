import 'package:get/get.dart';

import '../controllers/detail_surah_view_controller.dart';

class DetailSurahViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSurahViewController>(
      () => DetailSurahViewController(),
    );
  }
}
