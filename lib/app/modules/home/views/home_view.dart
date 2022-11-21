import 'package:alquran/app/constant/color.dart';
//gunakan alias untuk menghindari widget error karena terdekteksi sebagai model
import 'package:alquran/app/data/models/surah.dart';
import 'package:alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/detail_surah.dart' as detail;
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value =
          true; //chek for mode dark or light. for start app
    }

    return Scaffold(
      appBar: buildAppBar(),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Assalamualaikum",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text(
                "Hamba Allah",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              //Last Read
              GetBuilder<HomeController>(
                  builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                      future: c.getLastRead(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [colorGreenLight, colorGreenDark],
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  bottom: -50,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.7,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      child: Image.asset(
                                        "assets/images/quran-logo-green.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.menu_book_rounded,
                                            color: colorWhite,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Last Read",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: colorWhite),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Loading...",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: colorWhite),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "waiting for more seconds",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: colorWhite),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }

                        Map<String, dynamic>? lastRead = snapshot.data;

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                  colors: [colorGreenLight, colorGreenDark])),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onLongPress: () {
                                if (lastRead != null) {
                                  Get.defaultDialog(
                                      title: "Delete Last Read",
                                      middleText:
                                          "Are you sure to delete this last read bookmark ?",
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () => Get.back(),
                                            child: Text("CANCEL")),
                                        ElevatedButton(
                                            onPressed: () {
                                              c.deleteBookmark(lastRead["id"]);
                                            },
                                            child: Text("DELETE")),
                                      ]);
                                }
                              },
                              onTap: () {
                                if (lastRead != null) {
                                  //arahkan ke detail surah or detail juz
                                  switch (lastRead["via"]) {
                                    case "juz":
                                      Map<String, dynamic> dataMapPerJuz =
                                          controller
                                              .allJuz[lastRead["juz"] - 1];
                                      Get.toNamed(Routes.DETAIL_JUZ,
                                          arguments: {
                                            "juz": dataMapPerJuz,
                                            "bookmark": lastRead
                                          });
                                      break;
                                    default:
                                      Get.toNamed(Routes.DETAIL_SURAH_VIEW,
                                          arguments: {
                                            "name": lastRead["surah"]
                                                .toString()
                                                .replaceAll("+", "'"),
                                            "number": lastRead["number_surah"],
                                            "bookmark":
                                                lastRead, //melempar data bookmark
                                          });
                                      break;
                                  }
                                }
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    bottom: -50,
                                    right: 0,
                                    child: Opacity(
                                      opacity: 0.7,
                                      child: Container(
                                        width: 200,
                                        height: 200,
                                        child: Image.asset(
                                          "assets/images/quran-logo-green.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.menu_book_rounded,
                                              color: colorWhite,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Last Read",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorWhite),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        if (lastRead != null)
                                          Text(
                                            "${lastRead["surah"].toString().replaceAll("+", "'")}",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: colorWhite),
                                          ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          lastRead == null
                                              ? "Belum ada data \n "
                                              : "Juz ${lastRead["juz"]} | Ayat ${lastRead["ayat"]}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: colorWhite),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
              SizedBox(
                height: 20,
              ),
              //for change color in tabbar any options. can using Obx or Set tabbarTheme
              //Obx(
              //() =>
              TabBar(
                ///USED FOR Obx
                // indicatorColor:
                //     controller.isDark.isTrue ? colorWhite : colorPurpleDark,
                // labelColor:
                //     controller.isDark.isTrue ? colorWhite : colorPurpleDark,
                // labelStyle: TextStyle(fontWeight: FontWeight.bold),
                // unselectedLabelStyle:
                //     TextStyle(fontWeight: FontWeight.normal),
                // unselectedLabelColor: Colors.grey,
                tabs: const <Widget>[
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
              //),
              Expanded(
                child: TabBarView(children: <Widget>[
                  ///Surah
                  FutureBuilder<List<Surah>>(
                      future: controller.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("Tidak ada data"),
                          );
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Surah surah = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_SURAH_VIEW,
                                      arguments: {
                                        //kita masukan argument untuk dapat name nya aja
                                        "name": surah.name!.transliteration!.id,
                                        "number": surah.number!,
                                      });
                                },
                                //set with obx. so that can rebuild
                                leading: Obx(() => Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(controller
                                                  .isDark.isTrue
                                              ? "assets/images/num-border-dark.png"
                                              : "assets/images/num-border-light-green.png"),
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${surah.number}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    )),
                                title: Text(
                                  "${surah.name?.transliteration?.id ?? "Error.."}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  "${surah.numberOfVerses} Ayat | ${surah.revelation?.id ?? "Error.."}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600),
                                ),
                                trailing: Text(
                                  "${surah.name?.short ?? "Error.."}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            });
                      }),

                  ///Juz
                  //Used for alternative if api juz not completed
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: controller.getAllJuz(),
                    builder: (context, snapshot) {
                      //saat menunggu snapshot cek dlu
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        controller.addDataAllJuz.value =
                            false; //ketika waiting data kita set false
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text("Tidak ada data"),
                        );
                      }
                      controller.addDataAllJuz.value =
                          true; //jika sudah ada data kita set true
                      return ListView.builder(
                          itemCount: snapshot.data!
                              .length, //harusnya data 30 juz dari 29 index
                          itemBuilder: (context, index) {
                            Map<String, dynamic> dataMapPerJuz =
                                snapshot.data![index]; //lempar ke detail juz
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_JUZ,
                                    arguments: {"juz": dataMapPerJuz});
                              },
                              leading: Obx(
                                () => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(controller.isDark.isTrue
                                          ? "assets/images/num-border-dark.png"
                                          : "assets/images/num-border-light-green.png"),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                        color: Get.isDarkMode
                                            ? colorWhite
                                            : colorGreenDark,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "Mulai di ${(dataMapPerJuz['start']['surah'] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number?.inSurah}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Berakhir di ${(dataMapPerJuz['end']['surah'] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number?.inSurah}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),

                  //Used if api juz completed
                  // FutureBuilder<List<juz.Juz>>(
                  //     future: controller.getAllJuz(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       if (!snapshot.hasData) {
                  //         return Center(
                  //           child: Text("Tidak ada data"),
                  //         );
                  //       }
                  //       return ListView.builder(
                  //           itemCount: snapshot.data!.length,
                  //           itemBuilder: (context, index) {
                  //             //contoh pertama adalah juz 1 => index ke 0
                  //             juz.Juz detailJuz = snapshot.data![index];

                  //             //Lempar surah yang sudah di dapat dalam list ke dalam Juz
                  //             String nameStart =
                  //                 detailJuz.juzStartInfo?.split(" - ").first ??
                  //                     "";
                  //             String nameEnd =
                  //                 detailJuz.juzEndInfo?.split(" - ").first ??
                  //                     "";

                  //             List<Surah> allSurahInJuz =
                  //                 []; //fix data //masukan semua surah kedalam arraylist
                  //             List<Surah> rawAllSurahInJuz = [];

                  //             //proses perbandingan
                  //             //gunakan for in karena mendapatkan surah dari controller
                  //             ///item disini adalah item per surah
                  //             for (Surah item in controller.allSurah) {
                  //               rawAllSurahInJuz.add(item);
                  //               if (item.name!.transliteration!.id == nameEnd) {
                  //                 break;
                  //               }
                  //             }
                  //             //rawAllSurahInJuz harus di reserve agar ketika looping mulai dari belakang alalu akan stop jika nama sudah ssama dengan nameStart dan ubah ke dalam bentuk list
                  //             for (Surah item
                  //                 in rawAllSurahInJuz.reversed.toList()) {
                  //               allSurahInJuz.add(item);
                  //               if (item.name!.transliteration!.id ==
                  //                   nameStart) {
                  //                 break;
                  //               }
                  //             }

                  //             return ListTile(
                  //               onTap: () {
                  //                 Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                  //                   "juz": detailJuz,

                  //                   ///agar tidak terbalik urutan pengambuilan nama surah dalam juz maka kita reversed lagi disini
                  //                   "surah": allSurahInJuz.reversed.toList(),
                  //                 });
                  //               },
                  //               leading: Obx(
                  //                 () => Container(
                  //                   height: 35,
                  //                   width: 35,
                  //                   decoration: BoxDecoration(
                  //                     image: DecorationImage(
                  //                       image: AssetImage(controller
                  //                               .isDark.isTrue
                  //                           ? "assets/images/num-border-dark.png"
                  //                           : "assets/images/num-border-light.png"),
                  //                     ),
                  //                   ),
                  //                   child: Center(
                  //                       child: Text(
                  //                     "${index + 1}",
                  //                     style: TextStyle(
                  //                         color: Get.isDarkMode
                  //                             ? colorWhite
                  //                             : colorPurpleDark,
                  //                         fontSize: 12,
                  //                         fontWeight: FontWeight.w600),
                  //                   )),
                  //                 ),
                  //               ),
                  //               title: Text(
                  //                 "Juz ${index + 1}",
                  //                 style: TextStyle(
                  //                     fontSize: 16,
                  //                     fontWeight: FontWeight.w600),
                  //               ),
                  //               isThreeLine: true,
                  //               subtitle: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 children: <Widget>[
                  //                   Text(
                  //                     "Mulai di ${detailJuz.juzStartInfo}",
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       color: Colors.grey[500],
                  //                       fontWeight: FontWeight.w600,
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "Berakhir di ${detailJuz.juzEndInfo}",
                  //                     style: TextStyle(
                  //                       fontSize: 16,
                  //                       color: Colors.grey[500],
                  //                       fontWeight: FontWeight.w600,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             );
                  //           });
                  //     }),

                  ///Bookmark
                  GetBuilder<HomeController>(
                    builder: (c) {
                      if (c.addDataAllJuz.isFalse) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Sedang menunggu data juz..."),
                            ],
                          ),
                        );
                      } else {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: c.getBookmark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            //cek dulu ada data tidak
                            if (snapshot.data?.length == 0) {
                              return Center(
                                  child: Text("Bookmark belum tersedia"));
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                  onTap: () {
                                    switch (data["via"]) {
                                      case "juz":
                                        print("GO TO JUZ");
                                        print(data);
                                        Map<String, dynamic> dataMapPerJuz =
                                            controller.allJuz[data["juz"] - 1];
                                        Get.toNamed(Routes.DETAIL_JUZ,
                                            arguments: {
                                              "juz": dataMapPerJuz,
                                              "bookmark": data
                                            });
                                        break;
                                      default:
                                        print(data); // untuk cek output
                                        Get.toNamed(Routes.DETAIL_SURAH_VIEW,
                                            arguments: {
                                              "name": data["surah"]
                                                  .toString()
                                                  .replaceAll("+", "'"),
                                              "number": data["number_surah"],
                                              "bookmark":
                                                  data, //melempar data bookmark
                                            });
                                        break;
                                    }
                                  },
                                  leading: Obx(() => Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(controller
                                                    .isDark.isTrue
                                                ? "assets/images/num-border-dark.png"
                                                : "assets/images/num-border-light-green.png"),
                                          ),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        )),
                                      )),
                                  title: Text(
                                    "${data["surah"].toString().replaceAll("+", "'")}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    "Ayat ${data["ayat"]} - Dari ${data["via"]}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      print(data); //cek yang di dapat

                                      c.deleteBookmark(
                                          data['id']); //delete by id
                                    },
                                    icon: Obx(
                                      () => Icon(
                                        Icons.delete,
                                        color: controller.isDark.isTrue
                                            ? colorWhite
                                            : colorGreenDark,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  )
                ]),
              )
            ],
          ),
        ),
      ),

      ///simple button change theme
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeThemeMode(),
        child: Obx(
          () => Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? colorGreenDark : colorWhite,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Al-Quran'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () => Get.toNamed(Routes.SEARCH),
            icon: Icon(Icons.search))
      ],
    );
  }
}
