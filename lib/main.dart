import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_notes/write_notes_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'mycontroller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(GetMaterialApp(
    theme: ThemeData(
        appBarTheme: AppBarTheme(
            color: Colors.black,
            iconTheme: IconThemeData(color: Colors.white))),
    home: Main(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatefulWidget {
  static Database? database;

  Main();

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  Mycontroller m = Get.put(Mycontroller());
  bool temp = false;
  bool appbarbool = false;
  bool pin_appbarbool = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() {
    create_db();
    m.get();
    m.get_pinned();
    print("pinned length ${m.pinnedlist.length}");
    temp = true;
  }

  create_db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo1.db');

    Main.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      // await db.execute(
      //     'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)');
      await db.execute(
          'CREATE TABLE notes2 (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,note TEXT)');
      await db.execute(
          'CREATE TABLE pinned3 (id INTEGER PRIMARY KEY AUTOINCREMENT ,title TEXT,note TEXT)');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (appbarbool == false)
            ? AppBar(
                elevation: 0,
                title: Text("Writes Your Future",
                    style: TextStyle(color: Colors.white)),
                actions: [
                    IconButton(
                        onPressed: () {
                          m.grid_change_fun();

                          setState(() {});
                        },
                        icon: (m.gridtemp.value)
                            ? Icon(Icons.grid_view_rounded)
                            : Icon(Icons.grid_view))
                  ])
            : AppBar(
                leading: IconButton(
                    onPressed: () {
                      m.select_clear();
                      appbarbool = false;
                      setState(() {});
                    },
                    icon: Icon(Icons.close)),
                actions: (pin_appbarbool == false)
                    ? [
                        IconButton(
                            onPressed: () {
                              m.grid_change_fun();
                            },
                            icon: (m.gridtemp.value)
                                ? Icon(Icons.grid_view_rounded)
                                : Icon(Icons.grid_view)),
                        IconButton(
                            onPressed: () {
                              m.delete_selected();
                              m.select_clear();
                            },
                            icon: Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              m.transfer_pinned_id();
                              m.select_clear();
                            },
                            icon: Icon(Icons.push_pin)),
                        IconButton(
                            onPressed: () {
                              m.grid_change_fun();
                            },
                            icon: Icon(Icons.color_lens)),
                        IconButton(
                            onPressed: () {
                              m.grid_change_fun();
                            },
                            icon: Icon(Icons.label)),
                      ]
                    : [
                        IconButton(
                            onPressed: () {
                              m.remove_pinned();
                              m.select_clear();
                            },
                            icon: Icon(Icons.push_pin)),
                        IconButton(
                            onPressed: () {
                              m.grid_change_fun();
                            },
                            icon: (m.gridtemp.value)
                                ? Icon(Icons.grid_view_rounded)
                                : Icon(Icons.grid_view)),
                      ]),
        body: (temp)
            ? Obx(() => Container(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: (m.pinnedlist.length == 0)
                          ? [
                              Obx(() => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (m.gridtemp.value) ? 1 : 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemCount: m.l.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return WriteNotesPAge(
                                                      "others",
                                                      index,
                                                      m.l[index]['id']);
                                                },
                                              ));
                                            },
                                            onLongPress: () {
                                              m.select_fun("others", m.l.length,
                                                  index, m.l[index]['id']);

                                              if (m.delet_temp_list
                                                      .contains(true) ==
                                                  true) {
                                                appbarbool = true;
                                                print(
                                                    "app barr   ${appbarbool}");
                                              }
                                              if (m.delet_temp_list
                                                      .contains(true) !=
                                                  true) {
                                                appbarbool = false;
                                                print(appbarbool);
                                              }
                                              setState(() {});
                                            },
                                            child: Obx(() => Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: (m.delet_temp_list[
                                                              index])
                                                          ? Colors.black12
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: (m.delet_temp_list[
                                                              index])
                                                          ? Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3)
                                                          : Border.all(
                                                              color: Colors
                                                                  .black12,
                                                              width: 1)),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              m.l[index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontFamily:
                                                                      "f4",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              m.l[index]
                                                                  ['note'],
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                      },
                                    ),
                                  )),
                            ]
                          : [
                              Text(
                                "Pinned",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (m.gridtemp.value) ? 1 : 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemCount: m.pinnedlist.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return WriteNotesPAge(
                                                      "pinned",
                                                      index,
                                                      m.pinnedlist[index]
                                                          ['id']);
                                                },
                                              ));
                                            },
                                            onLongPress: () {
                                              m.select_fun(
                                                  "pinned",
                                                  m.pinnedlist.length,
                                                  index,
                                                  m.pinnedlist[index]['id']);

                                              if (m.remove_pinned_temp_list
                                                      .contains(true) ==
                                                  true) {
                                                pin_appbarbool = true;
                                                appbarbool = true;
                                                print(
                                                    "app barr   ${pin_appbarbool}");
                                              }
                                              if (m.remove_pinned_temp_list
                                                      .contains(true) !=
                                                  true) {
                                                pin_appbarbool = false;
                                                appbarbool = false;
                                                print(pin_appbarbool);
                                              }
                                              setState(() {});
                                            },
                                            child: Obx(() => Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: (m.remove_pinned_temp_list[
                                                              index])
                                                          ? Colors.black12
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border:
                                                          (m.remove_pinned_temp_list[
                                                                  index])
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 3)
                                                              : Border.all(
                                                                  color: Colors
                                                                      .black12,
                                                                  width: 1)),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              m.pinnedlist[
                                                                      index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontFamily:
                                                                      "f4",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              m.pinnedlist[
                                                                      index]
                                                                  ['note'],
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                      },
                                    ),
                                  )),
                              Text(
                                "Others",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                                  (m.gridtemp.value) ? 1 : 2,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5),
                                      itemCount: m.l.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return WriteNotesPAge(
                                                      "others",
                                                      index,
                                                      m.l[index]['id']);
                                                },
                                              ));
                                            },
                                            onLongPress: () {
                                              m.select_fun("others", m.l.length,
                                                  index, m.l[index]['id']);

                                              if (m.delet_temp_list
                                                      .contains(true) ==
                                                  true) {
                                                appbarbool = true;
                                                print(
                                                    "app barr   ${appbarbool}");
                                              }
                                              if (m.delet_temp_list
                                                      .contains(true) !=
                                                  true) {
                                                appbarbool = false;
                                                print(appbarbool);
                                              }
                                              setState(() {});
                                            },
                                            child: Obx(() => Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      color: (m.delet_temp_list[
                                                              index])
                                                          ? Colors.black12
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: (m.delet_temp_list[
                                                              index])
                                                          ? Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3)
                                                          : Border.all(
                                                              color: Colors
                                                                  .black12,
                                                              width: 1)),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              m.l[index]
                                                                  ['title'],
                                                              style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontFamily:
                                                                      "f4",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              m.l[index]
                                                                  ['note'],
                                                              maxLines: 5,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                )));
                                      },
                                    ),
                                  )),
                            ],
                    ),
                  ),
                ))
            : CircularProgressIndicator(),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return WriteNotesPAge();
                },
              ));
            }));
  }
}

class BackGroundTile extends StatelessWidget {
  final Color backgroundColor;
  final IconData icondata;

  BackGroundTile({required this.backgroundColor, required this.icondata});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Icon(icondata, color: Colors.white),
    );
  }
}

//StaggeredGridView.count(
//               crossAxisCount: 4,
//               staggeredTiles: _cardTile,
//               children: List.generate(10, (index) =>  Container(decoration: BoxDecoration(
//                   border: Border.all(width: 2,color: Colors.black)
//               )),),
//               mainAxisSpacing: 4.0,
//               crossAxisSpacing: 4.0,
//             )
