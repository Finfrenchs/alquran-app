import 'dart:convert';

import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/db/bookmark.dart';
import 'package:alquran/app/data/models/detail_surah.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

class DetailSurahViewController extends GetxController {
  AutoScrollController scrollC = AutoScrollController();
  // RxString audioCondition =
  //     "stop".obs; //berlaku untuk setiap ayat -> maka berubah semua
  final player = AudioPlayer();

  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  Future<void> addBookmark(
      bool lastRead, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;

    ///ad pengecekan untuk cek apakah last read sudah ada datanya jika sudah,
    ///maka akan di hapus  dan di ganti dengan last read yg terbaru
    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      //agar ketika bookmark tidak double
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and number_surah = ${surah.number!} and ayat = ${ayat.number!.inSurah} and juz = ${ayat.meta!.juz} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");

      if (checkData.length != 0) {
        // ada data
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": "${surah.name!.transliteration!.id!.replaceAll("'", "+")}",
          "number_surah": surah.number!,
          "ayat": ayat.number!.inSurah,
          "juz": ayat.meta!.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0,
        },
      );

      //after insert, close dialog
      Get.back();
      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark",
          colorText: colorWhite);
    } else {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Bookmark telah tersedia",
          colorText: colorWhite);
    }
    var data = await db.query("bookmark"); //cek data yg di terima
    print(data);
  }

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah/$id');
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)['data'];
    // DetailSurah test = DetailSurah.fromJson(data);
    // print(data); //cek response url
    // print(test);

    return DetailSurah.fromJson(data);
  }

  void stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.audioCondition = "stop";
      update(); //fungsinya sama denganm setState() jadi agar setiap di handle akan mengupdtaen kondisi
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "${e.message.toString()} / ${e.code.toString()}",
      );
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // Fallback for all other errors
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e / can't stop audio.",
      );
    }
  }

  void resumeAudio(Verse ayat) async {
    try {
      ayat.audioCondition = "playing";
      update();
      await player.play();
      ayat.audioCondition = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "${e.message.toString()} / ${e.code.toString()}",
      );
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // Fallback for all other errors
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e / can't resume audio.",
      );
    }
  }

  void pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.audioCondition = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "${e.message.toString()} / ${e.code.toString()}",
      );
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      // Fallback for all other errors
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "An error occured: $e / can't pause audio.",
      );
    }
  }

  void playAudio(Verse ayat) async {
    //cek audio
    if (ayat.audio?.primary != null) {
      // Catching errors at load time
      try {
        //mencegah terjadinya penumpukan audio yang berjalan
        if (lastVerse == null) {
          lastVerse = ayat; //menampung kodisi audio pertama yang di play
        }
        lastVerse!.audioCondition =
            "stop"; //stop kondisi audiop pertama yang di play
        lastVerse = ayat; //menampung kondisi audio kedua yang di play
        lastVerse!.audioCondition =
            "stop"; //stop kodisi jika pindah ayat yang di play
        update();
        await player
            .stop(); //mencegah terjadinya penumpukan audio yang sedang berjalan
        await player.setUrl(ayat.audio!.primary!);
        ayat.audioCondition = "playing";
        update();
        await player.play();
        ayat.audioCondition = "stop";
        await player.stop();
        update();
      } on PlayerException catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "${e.message.toString()} / ${e.code.toString()}",
        );
      } on PlayerInterruptedException catch (e) {
        // This call was interrupted since another audio source was loaded or the
        // player was stopped or disposed before this audio source could complete
        // loading.
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Connection aborted: ${e.message}",
        );
      } catch (e) {
        // Fallback for all other errors
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "An error occured: $e / can't play audio.",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "URL Audio tidak ada",
      );
    }
  }

  //close audio, if page back
  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
