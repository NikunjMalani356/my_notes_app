
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'main.dart';
import 'mycontroller.dart';

class WriteNotesPAge extends StatefulWidget {
  int? index;
  int? id;
  String? from;

  WriteNotesPAge([this.from,this.index, this.id]);

  @override
  State<WriteNotesPAge> createState() => _WriteNotesPAgeState();
}

class _WriteNotesPAgeState extends State<WriteNotesPAge> {
  TextEditingController t = TextEditingController();
  TextEditingController n = TextEditingController();
  Mycontroller m = Get.put(Mycontroller());
  bool temp = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    String title = t.text;
    String note = n.text;
    if (m.l[widget.index!] == null) {
      m.insert_note_fun(title, note);
    } else {
      m.update_note_fun(widget.id, t.text, n.text);
    }
    m.get();

    print(title);
    print(note);
  }

  get() {

    if (widget.from=="others" && widget.index != null && widget.id != null) {
      print("not null");
      t.text = m.l[widget.index!]['title'];
      n.text = m.l[widget.index!]['note'];
      print(m.l[0]['title']);
    }


    if (widget.from == "pinned" && widget.index != null && widget.id != null) {
      print("not null");
      t.text = m.pinnedlist[widget.index!]['title'];
      n.text = m.pinnedlist[widget.index!]['note'];
      print(m.pinnedlist[0]['title']);
    }
    temp = true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Main();
                },
              ));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Only Success Notes"),
          actions: [
            IconButton(
                onPressed: () {
                  String title = t.text;
                  String note = n.text;
                  if (widget.index == null) {
                    print("inserted");
                    m.insert_note_fun(title, note);
                  } else {
                    m.update_note_fun(widget.id, t.text, n.text);
                  }

                  print(title);
                  print(note);
                  setState(() {});
                },
                icon: Icon(Icons.save))
          ]),
      body: (temp)
          ? SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //    border: Border.all(color: Colors.black, width: 1)
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: 100,
                        child: TextField(
                          controller: t,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontFamily: "f4"),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Title",
                              hintStyle: TextStyle(color: Colors.black26)),
                        )),
                    SizedBox(
                      height: 500,
                      child: TextField(
                        controller: n,
                        maxLines: 100,
                        style: TextStyle(fontSize: 20, fontFamily: "f3"),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Note",
                            hintStyle: TextStyle(color: Colors.black26)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
