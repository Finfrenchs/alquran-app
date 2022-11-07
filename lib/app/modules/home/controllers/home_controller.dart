import 'package:alquran/app/data/db/bookmark.dart';
import 'package:alquran/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

import '../../../constant/color.dart';
import '../../../data/models/detail_surah.dart';

class HomeController extends GetxController {
  //extrack semua surah ke dalam list agar bisa di ambil datanya untuk menentukan nama surah yang ada di JUZ
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> allJuz = [];

  //set mode for change theme icon dark or light
  RxBool isDark = false.obs;
  RxBool addDataAllJuz = false.obs;

  //siapkan databe untuk mendapatkan bookmark
  DatabaseManager database = DatabaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead = await db.query(
      "bookmark",
      where: "last_read = 1",
    );
    //karena data last read di pastikan 1
    if (dataLastRead.length == 0) {
      //tidak ada data last read
      return null;
    } else {
      //ada data -> karena bentuknya list maka ambil index ke 0 (karena cuama da 1 data di dalam list last read)
      return dataLastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    db.delete("bookmark", where: "id = $id");
    update(); //agar langsung muncul perubahannya jika sudah di hapus
    Get.back(); //tutup dialog
    //beri notify
    Get.snackbar("Berhasil", "Telah berhasil menghapus bookmark",
        colorText: colorWhite);
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmark = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "juz, via, surah, ayat", //agar urut surah yag di bookmark
    );
    return allBookmark;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);

    //declaration for press button to change image
    isDark.toggle();

    //save mode set in get storage
    final box = GetStorage();

    if (Get.isDarkMode) {
      // dart => light
      box.remove("themeDark"); //key sesuikan yang ada di main
    } else {
      // light => dark
      box.write("themeDark", true);
    }
  }

  //get all surah
  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse('https://api.quran.gading.dev/surah');
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)['data'];

    if (data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  //get all juz
  ///Used for api juz completed
  // Future<List<Juz>> getAllJuz() async {
  //   //Jika sudah dapat datanya kita buat list untuk menampung juz yg di dapat
  //   List<Juz> allJuz = [];

  //   //karena tidak ada api untuk seluruh juz dan hanya per index juz maka kita looping
  //   for (int i = 1; i <= 30; i++) {
  //     Uri url = Uri.parse('https://api.quran.gading.dev/juz/$i');
  //     var res = await http.get(url);

  //     //karena bentuk data maping kita map
  //     Map<String, dynamic> data =
  //         (json.decode(res.body) as Map<String, dynamic>)['data'];

  //     //data kita lempar ke dalam variable object
  //     Juz juz = Juz.fromJson(data);
  //     // setelah menabahkan list, kita add
  //     allJuz.add(juz);

  //     ///Cek response json
  //     //print(allJuz);
  //     //print(juz);
  //     //print(data);
  //   }

  //   return allJuz;
  // }

  ///USED IF API JUZ NOT COMPLETED
  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1; //mualai dari juz 1
    List<Map<String, dynamic>> penampungAyat =
        []; //variablr ini untuk menampung ayat hasil looping

    //HARUS MELOOPING SETIAP SURAH AGAR BISA MEMBANDINGKAN SURAH TERSEBUT MASUK KE DALAM JUZ MANA
    for (var i = 1; i <= 114; i++) {
      var res =
          await http.get(Uri.parse("https://api.quran.gading.dev/surah/$i"));
      Map<String, dynamic> rawData = json.decode(res.body)["data"];
      //ubah data ke bentuk model
      DetailSurah data = DetailSurah.fromJson(rawData);
      //ambil ayatnya
      //kemungkinan ada datanya yang null maka di cek dulu sebelum looping

      if (data.verses != null) {
        //looping disini
        ///example: surah albacoroh => ratusan ayat
        ///ratusan ayat ini kita looping setiap ayatnya
        ///dan kita samakan dengan juz
        ///nah jika sama maka akan di tampung dulu kedalam list
        data.verses!.forEach((ayat) {
          if (ayat.meta?.juz == juz) {
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          } else {
            //karena masih di dalam step satu belum ada increment
            //maka masukan dulu surah nya
            allJuz.add({
              "juz": juz,
              "start": penampungAyat[0],
              "end": penampungAyat[penampungAyat.length - 1],
              "verses": penampungAyat,
            });
            //setelah itu baru di incrementt juznya
            juz++;
            //jangan lupa panampung ayat nya di clear dulu hapus dlu yang usdah di tambahkan sevbelumnya barus memasukan ayat selanjutnya
            penampungAyat = [];
            //setelah juz bertambah masukan ke dalam penampungan ke dua dan seterusnya
            penampungAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          }
        });
      }
    }

    ///menambahkan juz 30 kenapa di tambahkan disini
    ///karena agar bisa mendapatkan juz 30
    ///karena sebelum nya kita menambahkan ketika sudah beda dengan data juz

    //karena masih di dalam step satu belum ada increment
    //maka masukan dulu surah nya
    allJuz.add({
      "juz": juz,
      "start": penampungAyat[0],
      "end": penampungAyat[penampungAyat.length - 1],
      "verses": penampungAyat,
    });
    return allJuz;
  }
}
