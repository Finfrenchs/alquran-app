// import 'package:alquran/app/data/models/detail_surah.dart';
// import 'package:alquran/app/data/models/surah.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() async {
//   Uri url = Uri.parse('https://api.quran.gading.dev/surah');
//   var res = await http.get(url);

//   List data = (json.decode(res.body) as Map<String, dynamic>)['data'];

//   //1-114 surah -> index ke 113 = annas
//   ///print(data[113]);

//   //data from api (raw data) Model -> Model (yang sudah di siapkan)
//   Surah surahAnnas = Surah.fromJson(data[113]);

//   //print only 1
//   // print(surahAnnas.name);
//   // print(surahAnnas.number);
//   // print(surahAnnas.numberOfVerses);
//   // print(surahAnnas.revelation);
//   // print(surahAnnas.sequence);
//   // print(surahAnnas.tafsir);

//   //print All
//   /*print(surahAnnas.toJson());*/

//   //INI COBA MASUK KE NESTED MODEL
//   //print(surahAnnas.name?.long);

//   Uri urlAnnas =
//       Uri.parse('https://api.quran.gading.dev/surah/${surahAnnas.number}');
//   var resAnnas = await http.get(urlAnnas);

//   Map<String, dynamic> dataAnnas =
//       (json.decode(resAnnas.body) as Map<String, dynamic>)["data"];

//   //data from api (raw data) Model -> Model (yang sudah di siapkan)
//   DetailSurah annas = DetailSurah.fromJson(dataAnnas);
//   print(annas.verses![0].text!.arab);
//   print(annas.verses![0].text!.transliteration!.en);
//   print(annas.verses![0].translation!.id);
//   print(annas.verses![0].translation!.en);
// }

// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// String StringChallenge(String str) {

//   // code goes here
//   //'aar AND!@#
// List<String> exceptions = ['aar AND!@#'];

//   String toTitleCase(name) {
//     return this.replaceAllMapped(RegExp(r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
//         (Match match) {
//       if (exceptions.contains(match[0])) {
//         return match[0];
//       }
//       return "${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}";
//     }).replaceAll(RegExp(r'(_|-)+'), ' ');
//   }

//   str = exceptions as String;
//   return str;

// }

// // keep this function call here
// void main() {
//   print(StringChallenge(stdin.readLineSync()!));
// }

// import 'dart:io';
// int ArrayChallenge(List arr) {

//   var maxProfit = -1;
//   var buyPrice = 0;
//   var sellPrice = 0;

//   var change_buy_index = true;
//   10 9 8 7 5
//   for(var i = 0; i < arr.length-1; i++){
//     sellPrice = arr[i+1];

//     if(change_buy_index){
//       buyPrice = arr[i];
//     }
//     if(sellPrice < buyPrice) {
//       change_buy_index = true;
//       continue;
//     } else {
//       var tempProfit = sellPrice - buyPrice;
//       if(tempProfit > maxProfit) {
//         maxProfit = tempProfit;
//       }
//       change_buy_index = false;
//     }
//   }
//   return maxProfit;

// }

// // keep this function call here
// void main() {
//   print(ArrayChallenge(stdin.readLineSync()));
// }

// import 'package:alquran/app/data/models/ayat.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// void main() async {
//   var res =
//       await http.get(Uri.parse("https://api.quran.gading.dev/surah/108/1"));
//   Map<String, dynamic> data = json.decode(res.body)["data"];
//   //untuk memfilter didalam data yang tidak di ambil ke dalam model
//   Map<String, dynamic> dataToModel = {
//     "number": data["number"],
//     "meta": data["meta"],
//     "text": data["text"],
//     "translation": data["translation"],
//     "audio": data["audio"],
//     "tafsir": data["tafsir"],
//   };

//   //convert Map -> Model ayat
//   Ayat ayat = Ayat.fromJson(dataToModel);

//   print(ayat.tafsir?.id?.short);
// }

///PLAN ALTERNATIF JUZ API NOT COMPLETED
// [
//   [ayat ayat] juz 1 => index 0
//   [ayat ayat] juz 2 => index 1
//   ....
//   ....
//   sampai juz 30 => index 29
// ]

// //menyiapkan data kedalam bentuk
// List<List<Ayat>>

// juz 1
// [
//   {
//     "juz": 1,
//     "start": Ayat
//     "end": Ayat
//     "verses": [ayat ayat]
//   }
// ]
// juz 2
// [
//   {
//     "juz": 2,
//     "start": Ayat
//     "end": Ayat
//     "verses": [ayat ayat]
//   }
// ]

// List<Map<String, dynamic>>

import 'dart:convert';

import 'package:alquran/app/data/models/detail_surah.dart';
import 'package:http/http.dart' as http;

void main() async {
  int juz = 1; //mualai dari juz 1
  List<Map<String, dynamic>> penampungAyat =
      []; //variablr ini untuk menampung ayat hasil looping
  List<Map<String, dynamic>> allJuz = [];
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
            "surah": data.name?.transliteration?.id ?? "",
            "ayat": ayat,
          });
        } else {
          print("========");
          print("BERHASIL MEMASUKAN JUZ $juz");
          print("Start :");
          print(
              "Ayat : ${(penampungAyat[0]["ayat"] as Verse).number?.inSurah}");
          print((penampungAyat[0]["ayat"] as Verse).text?.arab);
          print("End :");
          print(
              "Ayat : ${(penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).number?.inSurah}");
          print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse)
              .text
              ?.arab);
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
          penampungAyat.clear();
          //setelah juz bertambah masukan ke dalam penampungan ke dua dan seterusnya
          penampungAyat.add({
            "surah": data.name?.transliteration?.id ?? "",
            "ayat": ayat,
          });
        }
      });
    }
  }

  ///menambahkan juz 30 kenapa di tambahkan disini
  ///karena agar bisa mendapatkan juz 30
  ///karena sebelum nya kita menambahkan ketika sudah beda dengan data juz
  print("========");
  print("BERHASIL MEMASUKAN JUZ $juz");
  print("Start :");
  print("Ayat : ${(penampungAyat[0]["ayat"] as Verse).number?.inSurah}");
  print((penampungAyat[0]["ayat"] as Verse).text?.arab);
  print("End :");
  print(
      "Ayat : ${(penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).number?.inSurah}");
  print((penampungAyat[penampungAyat.length - 1]["ayat"] as Verse).text?.arab);
  //karena masih di dalam step satu belum ada increment
  //maka masukan dulu surah nya
  allJuz.add({
    "juz": juz,
    "start": penampungAyat[0],
    "end": penampungAyat[penampungAyat.length - 1],
    "verses": penampungAyat,
  });
}
