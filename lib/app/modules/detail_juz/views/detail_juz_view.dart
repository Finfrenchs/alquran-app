//for api juz complate
import 'package:alquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constant/color.dart';
import '../../../data/models/detail_surah.dart' as detail;
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;

  //get Juz and Get surah setelah di masukan delama argument
  // final juz.Juz detailJuz = Get.arguments["juz"]; //used for api juz completed
  // final List<Surah> allSurahInThisJuz = Get.arguments["surah"];
  final Map<String, dynamic> dataMapPerJuz =
      Get.arguments["juz"]; //used for api juz not complted (alternative)

  @override
  Widget build(BuildContext context) {
    //cek hasil looping saat ngebuild
    ///used if api juz complete
    // allSurahInThisJuz.forEach((element) {
    //   print(element.name!.transliteration!.id);
    // });

    //setelah mendapat data
    //cek data bookmark dan mendapatkan data
    if (Get.arguments["bookmark"] != null) {
      bookmark = Get.arguments["bookmark"];

      //codisi ini untuk agar ketika yang di safe adalah ayat pertama maka tidak auto scroll
      if (bookmark!["index_ayat"] > 0) {
        print("INDEX AYAT : ${bookmark!["index_ayat"]}");
        print("GO TO INDEX AUTO SCROLL : ${bookmark!["index_ayat"]}");
        controller.scrollC.scrollToIndex(
          bookmark![
              "index_ayat"], //tidak di tambah 2 karena hanya ada 1 widget di dalam children
          preferPosition: AutoScrollPosition.begin,
        );
      }
    }
    print(bookmark); //tampilkan bookmark yg masuk apa aja

    List<Widget> allAyat = List.generate(
        //detailJuz.verses?.length ?? 0, //used for api juz complete
        (dataMapPerJuz["verses"] as List).length, //used api not completed
        (index) {
      //Get Ayat
      Map<String, dynamic> ayat =
          dataMapPerJuz["verses"][index]; //alternatif api not complete

      //ambil surah untuk on Tap dan judul nama surah(alternatif api juz no complete)
      detail.DetailSurah surah = ayat["surah"];
      detail.Verse verse = ayat["ayat"];

      ///USED IF API JUZ COMPLETE
      // if (detailJuz.verses == null || detailJuz.verses?.length == 0) {
      //   return Center(
      //     child: Text("Tidak ada data"),
      //   );
      // }
      // juz.Verses ayat = detailJuz.verses![index];
      // //icrement index for name following index that is get
      // if (index != 0) {
      //   if (ayat.number?.inSurah == 1) {
      //     controller.index++;
      //   }
      // }
      return AutoScrollTag(
        key: ValueKey(index),
        controller: controller.scrollC,
        index: index,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //if (ayat.number?.inSurah == 1)
              if (verse.number?.inSurah == 1) //used api not complete
                GestureDetector(
                  ///CUSTOM DIALOG
                  onTap: () => Get.dialog(Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? colorGreenSoft.withOpacity(0.4)
                            : colorWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, //so that follow content
                        children: <Widget>[
                          Text(
                            "Tafsir ${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            //"Tafsir ${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            //"${surah.tafsir?.id ?? "Tidak ada tafsir pada surah ini"}",
                            "${surah.tafsir?.id ?? "Tidak ada tafsir pada surah ini"}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [colorGreenLight, colorGreenDark])),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            //"${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            style: TextStyle(
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${surah.name?.translation?.id?.toUpperCase() ?? "Error..."}",
                            //"{${surah.name?.translation?.id?.toUpperCase() ?? "Error..."}}",
                            style: TextStyle(
                                fontSize: 18,
                                color: colorWhite,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${surah.numberOfVerses ?? "Error..."} Ayat | ${surah.revelation?.id ?? "Error..."}",
                            //"${surah.numberOfVerses ?? "Error..."} Ayat | ${surah.revelation?.id ?? "Error..."}",
                            style: TextStyle(
                                fontSize: 16,
                                color: colorWhite,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Get.isDarkMode
                        ? colorGreenSoft.withOpacity(0.2)
                        : colorGreenLight.withOpacity(0.08)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize:
                            MainAxisSize.min, //will follow lengt content
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Get.isDarkMode
                                      ? "assets/images/num-border-dark.png"
                                      : "assets/images/num-border-light-green.png"),
                                  fit: BoxFit.contain),
                            ),
                            child: Center(
                              child:
                                  //Text(
                                  //     "${ayat.number?.inSurah}"), //for api juz completed
                                  Text("${verse.number?.inSurah}"),
                            ),
                          ),

                          //FOR API JUZ COMPLETE
                          // Text(
                          //   "${allSurahInThisJuz[controller.index].name?.transliteration?.id ?? ""}",
                          //   style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.bold,
                          //       fontStyle: FontStyle.italic),
                          // ),

                          Text(
                            "${surah.name?.transliteration?.id}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      GetBuilder<DetailJuzController>(
                        builder: (c) => Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.defaultDialog(
                                    title: "BOOKMARK",
                                    middleText: "Pilih jenis bookmark",
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await c.addBookmark(
                                              true, surah, verse, index);
                                          homeC.update();
                                        },
                                        child: Text("LAST READ"),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: colorGreen),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          c.addBookmark(
                                              false, surah, verse, index);
                                        },
                                        child: Text("BOOKMARK"),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: colorGreen),
                                      )
                                    ]);
                              },
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Get.isDarkMode
                                    ? colorWhite
                                    : colorGreenDark,
                              ),
                            ),
                            (verse.audioCondition == "stop")
                                ? IconButton(
                                    onPressed: () {
                                      c.playAudio(verse);
                                    },
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Get.isDarkMode
                                          ? colorWhite
                                          : colorGreenDark,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      (verse.audioCondition == "playing")
                                          ? IconButton(
                                              onPressed: () {
                                                c.pauseAudio(verse);
                                              },
                                              icon: Icon(
                                                Icons.pause,
                                                color: Get.isDarkMode
                                                    ? colorWhite
                                                    : colorGreenDark,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                c.resumeAudio(verse);
                                              },
                                              icon: Icon(
                                                Icons.play_arrow,
                                                color: Get.isDarkMode
                                                    ? colorWhite
                                                    : colorGreenDark,
                                              ),
                                            ),
                                      IconButton(
                                        onPressed: () {
                                          c.stopAudio(verse);
                                        },
                                        icon: Icon(
                                          Icons.stop,
                                          color: Get.isDarkMode
                                              ? colorWhite
                                              : colorGreenDark,
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                //"${ayat.text?.arab}",
                "${(ayat['ayat'] as detail.Verse).text?.arab}",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                //"${ayat.text?.transliteration?.en}",
                "${(ayat['ayat'] as detail.Verse).text?.transliteration?.en}",
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Get.isDarkMode ? Colors.white70 : Colors.brown),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                //"${ayat.translation?.id}",
                "${(ayat['ayat'] as detail.Verse).translation?.id}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    color: Get.isDarkMode ? Colors.white60 : Colors.blueGrey,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        //title: Text('Juz ${detailJuz.juz}'), //used for api juz complete
        title: Text('Juz ${dataMapPerJuz["juz"]}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        controller: controller.scrollC,
        children: allAyat,
      ),
    );
  }
}
