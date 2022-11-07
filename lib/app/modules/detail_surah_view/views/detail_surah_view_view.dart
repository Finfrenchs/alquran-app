import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/models/detail_surah.dart' as detail;
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/detail_surah_view_controller.dart';

class DetailSurahViewView extends GetView<DetailSurahViewController> {
  //final Surah surah = Get.arguments; //tidak di perlukan lagi karena tidak mendapatkan data surah keseluruhan
  //inject home controller disni agar ketika last read di ganti agar bisa langsung di update
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark; //untuk menampuk data bookmark
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SURAH ${Get.arguments["name"].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments["number"].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }

          //setelah mendapat data
          //cek data bookmark dan mendapatkan data
          if (Get.arguments["bookmark"] != null) {
            bookmark = Get.arguments["bookmark"];

            //codisi ini untuk agar ketika yang di safe adalah ayat pertama maka tidak auto scroll
            if (bookmark!["index_ayat"] > 0) {
              print("INDEX AYAT : ${bookmark!["index_ayat"]}");
              print("GO TO INDEX AUTO SCROLL : ${bookmark!["index_ayat"] + 2}");
              controller.scrollC.scrollToIndex(
                bookmark!["index_ayat"] +
                    2, //di tambah 2 karena menggunakan autoscrolltag maka kita akan memulai scroll di index 2 dari autoscroltag
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark); //tampilkan bookmark yg masuk apa aja

          detail.DetailSurah surah = snapshot.data!;

          //GUNAKAN LIST WIDGET AGAR KETIKA autoscrol dapat berada di posisi atas tanpa terhalang efek dari listview builder
          List<Widget> allAyat =
              List.generate(snapshot.data?.verses?.length ?? 0, (index) {
            detail.Verse? ayat = snapshot.data?.verses?[index];

            return AutoScrollTag(
              key: ValueKey(index + 2),
              index: index + 2,
              controller: controller.scrollC,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Get.isDarkMode
                            ? colorPurpleSoft.withOpacity(0.2)
                            : colorPurpleLight.withOpacity(0.08)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Get.isDarkMode
                                      ? "assets/images/num-border-dark.png"
                                      : "assets/images/num-border-light.png"),
                                  fit: BoxFit.contain),
                            ),
                            child: Center(
                              child: Text("${index + 1}"),
                            ),
                          ),
                          GetBuilder<DetailSurahViewController>(
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
                                              await c.addBookmark(true,
                                                  snapshot.data!, ayat!, index);
                                              //update disini agar bisa langsung muncul/ngeload ketika kembali ke tampilan home
                                              homeC.update();
                                            },
                                            child: Text("LAST READ"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: colorPurple),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              c.addBookmark(false,
                                                  snapshot.data!, ayat!, index);
                                            },
                                            child: Text("BOOKMARK"),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: colorPurple),
                                          )
                                        ]);
                                  },
                                  icon: Icon(
                                    Icons.bookmark_border,
                                    color: Get.isDarkMode
                                        ? colorWhite
                                        : colorPurpleDark,
                                  ),
                                ),
                                (ayat?.audioCondition == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(ayat!);
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Get.isDarkMode
                                              ? colorWhite
                                              : colorPurpleDark,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          (ayat?.audioCondition == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(ayat!);
                                                  },
                                                  icon: Icon(
                                                    Icons.pause,
                                                    color: Get.isDarkMode
                                                        ? colorWhite
                                                        : colorPurpleDark,
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(ayat!);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow,
                                                    color: Get.isDarkMode
                                                        ? colorWhite
                                                        : colorPurpleDark,
                                                  ),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              c.stopAudio(ayat!);
                                            },
                                            icon: Icon(
                                              Icons.stop,
                                              color: Get.isDarkMode
                                                  ? colorWhite
                                                  : colorPurpleDark,
                                            ),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${ayat!.text?.arab}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${ayat.text?.transliteration?.en}",
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
                    "${ayat.translation?.id}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            Get.isDarkMode ? Colors.white60 : Colors.blueGrey,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            );
          });

          //sudah dipastika ada data
          return ListView(
            controller: controller.scrollC,
            padding: EdgeInsets.all(15.0),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  ///CUSTOM DIALOG
                  onTap: () => Get.dialog(Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? colorPurpleSoft.withOpacity(0.4)
                            : colorWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, //so that follow content
                        children: <Widget>[
                          Text(
                            "Tafsir ${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${surah.tafsir?.id ?? "Tidak ada tafsir pada surah ini"}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )),
                  // onTap: () => Get.defaultDialog(
                  //     contentPadding:
                  //         EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  //     title:
                  //         "Tafsir ${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                  //     titleStyle: TextStyle(fontWeight: FontWeight.bold),
                  //     content: Container(
                  //       height: MediaQuery.of(context).size.height * 0.5,
                  //       child: Text(
                  //         "${surah.tafsir?.id ?? "Tidak ada tafsir pada surah ini"}",
                  //         textAlign: TextAlign.left,
                  //       ),
                  //     )
                  //     //middleText: "${surah.tafsir?.id ?? "Tidak ada tafsir pada surah ini"}",
                  //     ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [colorPurpleLight, colorPurpleDark])),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${surah.name?.transliteration?.id?.toUpperCase() ?? "Error..."}",
                            style: TextStyle(
                                fontSize: 20,
                                color: colorWhite,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "{${surah.name?.translation?.id?.toUpperCase() ?? "Error..."}}",
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
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: SizedBox(
                  height: 20,
                ),
              ),
              ...allAyat,
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: snapshot.data?.verses?.length ?? 0,
              //   itemBuilder: (context, index) {
              //     print(index); //cek apa yang di build
              //     if (snapshot.data?.verses?.length == 0) {
              //       return SizedBox();
              //     }

              //     detail.Verse? ayat = snapshot.data?.verses?[index];

              //     return AutoScrollTag(
              //       key: ValueKey(index + 2),
              //       index: index + 2,
              //       controller: controller.scrollC,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           Container(
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: Get.isDarkMode
              //                     ? colorPurpleSoft.withOpacity(0.2)
              //                     : colorPurpleLight.withOpacity(0.08)),
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(
              //                   vertical: 10, horizontal: 10),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Container(
              //                     width: 40,
              //                     height: 40,
              //                     decoration: BoxDecoration(
              //                       image: DecorationImage(
              //                           image: AssetImage(Get.isDarkMode
              //                               ? "assets/images/num-border-dark.png"
              //                               : "assets/images/num-border-light.png"),
              //                           fit: BoxFit.contain),
              //                     ),
              //                     child: Center(
              //                       child: Text("${index + 1}"),
              //                     ),
              //                   ),
              //                   GetBuilder<DetailSurahViewController>(
              //                     builder: (c) => Row(
              //                       children: [
              //                         IconButton(
              //                           onPressed: () {
              //                             Get.defaultDialog(
              //                                 title: "BOOKMARK",
              //                                 middleText:
              //                                     "Pilih jenis bookmark",
              //                                 actions: [
              //                                   ElevatedButton(
              //                                     onPressed: () async {
              //                                       await c.addBookmark(
              //                                           true,
              //                                           snapshot.data!,
              //                                           ayat!,
              //                                           index);
              //                                       //update disini agar bisa langsung muncul/ngeload ketika kembali ke tampilan home
              //                                       homeC.update();
              //                                     },
              //                                     child: Text("LAST READ"),
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                             primary: colorPurple),
              //                                   ),
              //                                   ElevatedButton(
              //                                     onPressed: () {
              //                                       c.addBookmark(
              //                                           false,
              //                                           snapshot.data!,
              //                                           ayat!,
              //                                           index);
              //                                     },
              //                                     child: Text("BOOKMARK"),
              //                                     style:
              //                                         ElevatedButton.styleFrom(
              //                                             primary: colorPurple),
              //                                   )
              //                                 ]);
              //                           },
              //                           icon: Icon(
              //                             Icons.bookmark_border,
              //                             color: Get.isDarkMode
              //                                 ? colorWhite
              //                                 : colorPurpleDark,
              //                           ),
              //                         ),
              //                         (ayat?.audioCondition == "stop")
              //                             ? IconButton(
              //                                 onPressed: () {
              //                                   c.playAudio(ayat!);
              //                                 },
              //                                 icon: Icon(
              //                                   Icons.play_arrow,
              //                                   color: Get.isDarkMode
              //                                       ? colorWhite
              //                                       : colorPurpleDark,
              //                                 ),
              //                               )
              //                             : Row(
              //                                 mainAxisSize: MainAxisSize.min,
              //                                 children: <Widget>[
              //                                   (ayat?.audioCondition ==
              //                                           "playing")
              //                                       ? IconButton(
              //                                           onPressed: () {
              //                                             c.pauseAudio(ayat!);
              //                                           },
              //                                           icon: Icon(
              //                                             Icons.pause,
              //                                             color: Get.isDarkMode
              //                                                 ? colorWhite
              //                                                 : colorPurpleDark,
              //                                           ),
              //                                         )
              //                                       : IconButton(
              //                                           onPressed: () {
              //                                             c.resumeAudio(ayat!);
              //                                           },
              //                                           icon: Icon(
              //                                             Icons.play_arrow,
              //                                             color: Get.isDarkMode
              //                                                 ? colorWhite
              //                                                 : colorPurpleDark,
              //                                           ),
              //                                         ),
              //                                   IconButton(
              //                                     onPressed: () {
              //                                       c.stopAudio(ayat!);
              //                                     },
              //                                     icon: Icon(
              //                                       Icons.stop,
              //                                       color: Get.isDarkMode
              //                                           ? colorWhite
              //                                           : colorPurpleDark,
              //                                     ),
              //                                   )
              //                                 ],
              //                               ),
              //                       ],
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             height: 20,
              //           ),
              //           Text(
              //             "${ayat!.text?.arab}",
              //             textAlign: TextAlign.end,
              //             style: TextStyle(
              //               fontSize: 25,
              //             ),
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           Text(
              //             "${ayat.text?.transliteration?.en}",
              //             textAlign: TextAlign.end,
              //             style: TextStyle(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600,
              //                 color: Get.isDarkMode
              //                     ? Colors.white70
              //                     : Colors.brown),
              //           ),
              //           SizedBox(
              //             height: 20,
              //           ),
              //           Text(
              //             "${ayat.translation?.id}",
              //             textAlign: TextAlign.left,
              //             style: TextStyle(
              //                 fontSize: 16,
              //                 color: Get.isDarkMode
              //                     ? Colors.white60
              //                     : Colors.blueGrey,
              //                 fontStyle: FontStyle.italic),
              //           ),
              //           SizedBox(
              //             height: 30,
              //           )
              //         ],
              //       ),
              //     );
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
