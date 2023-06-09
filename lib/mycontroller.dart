import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class Mycontroller extends GetxController
{

  
  RxBool gridtemp = false.obs;
  RxBool appbarbool= false.obs;
  RxBool pin_appbarbool= false.obs;
  
  RxList selected_ind= [].obs;
  RxList selected_ids = [].obs;
  RxList pinned_ids = [].obs;
  RxList remove_pinned_ids = [].obs;
  RxList l = [].obs;
  RxList pinnedlist = [].obs;
  
  RxList<bool> delet_temp_list = List.filled(100, false).obs;
  RxList<bool> remove_pinned_temp_list = List.filled(100, false).obs;

  Future<Database> get_database()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo1.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table

          await db.execute(
              'CREATE TABLE notes2 (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,note TEXT)');

          await db.execute(
              'CREATE TABLE pinned3 (id INTEGER PRIMARY KEY AUTOINCREMENT ,title TEXT,note TEXT)');
        });
    return database;
  }

  insert_note_fun(title,note)
  async {
    print("insert enterd.");

    String qry ="insert into notes2 values(null,'$title','$note')";
    Main.database!.rawInsert(qry);
  }

  Future get()async
  {
    print("get notes2 entred");
    get_database().then((value) async {
      String sql="select * from notes2";
      value.rawQuery(sql).then((value){
        l.value=value;
        print("List ${l.value}");
      });
    });
  }


  update_note_fun(id,title,note)
  {
    String qry ="UPDATE notes2 SET title = '${title}',note = '${note}' WHERE id='${id}'";
    Main.database!.rawInsert(qry);
  }

  delete_selected()
  {
    selected_ids.forEach((element) {
      String qry3 ="delete from notes2 where id='${element}'";
      Main.database!.rawInsert(qry3);

      selected_ids.value.forEach((element) {
        String qry3 ="delete from pinned3 where id='${element}'";
        print(element);
        Main.database!.rawInsert(qry3);
      });
      get_pinned();

      get();
      get_pinned();
    });
  }

  remove_pinned()
  {

    get_pinned();
    pinnedlist.value.forEach((element) {
      String qry3 ="delete from pinned3 where id='${element['id']}'";
      print(element);
      Main.database!.rawInsert(qry3);
    });
    get_pinned();
  }

  select_fun(from,length,index,id)
  {
    if(from=="others")
    {
      delet_temp_list[index]=!delet_temp_list[index];
      if(delet_temp_list.contains(true)==true)
      {
        appbarbool.value = true;
        print("app barr   ${appbarbool.value}");
      }
      if(delet_temp_list.contains(true)!=true)
      {
        appbarbool.value = false;
        print(appbarbool.value);
      }

      if(delet_temp_list[index]==true)
      {
        selected_ids.add(id);
        pinned_ids.add(id);
        remove_pinned_ids.add(id);

      }
      if(delet_temp_list[index]==false)
      {
        selected_ids.removeWhere((element) => element == id);
        pinned_ids.removeWhere((element) => element == id);
        remove_pinned_ids.removeWhere((element) => element == id);
      }
      print("selected ids ${selected_ids}");
      print("remove pinned ids ${remove_pinned_ids}");

    }
    if(from=="pinned")
    {
      remove_pinned_temp_list[index]=!remove_pinned_temp_list[index];
      if(remove_pinned_temp_list.contains(true)==true)
      {
        pin_appbarbool.value = true;
        print("app barr   ${pin_appbarbool.value}");
      }
      if(delet_temp_list.contains(true)!=true)
      {
        pin_appbarbool.value = false;
        print(pin_appbarbool.value);
      }

      if(remove_pinned_temp_list[index]==true)
      {
        remove_pinned_ids.add(id);
      }
      if(delet_temp_list[index]==false)
      {
        remove_pinned_ids.removeWhere((element) => element == id);
      }
      print("selected ids ${selected_ids}");
      print("remove pinned ids ${remove_pinned_ids}");
    }
  }

  select_clear()
  {
    appbarbool.value = false;
    delet_temp_list.value = List.filled(100, false);
    selected_ids=[].obs;
    remove_pinned_temp_list = List.filled(100, false).obs;

  }



  Future transfer_pinned_id()async
  {
    get_database().then((value) async {
      pinned_ids.forEach((element) {
        String sql= "INSERT INTO pinned3 (id, title, note) SELECT id, title, note FROM notes2 WHERE id ='${element}'";
        value.rawQuery(sql);
      });
    });
    get_pinned();
    //detele_transrfed();
    get();
    get_pinned();
  }

  Future get_pinned()async
  {

    get_database().then((value) async {
        String sql="select * from pinned3";
        value.rawQuery(sql).then((value){
          pinnedlist.value=value;
          print("pinnedList ${pinnedlist.value}");
        });
    });
  }

  grid_change_fun()
  {
    gridtemp.value =! gridtemp.value;
    print("grid temp ${gridtemp}");
  }


}