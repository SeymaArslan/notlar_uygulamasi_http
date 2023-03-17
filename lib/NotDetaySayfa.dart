import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi_http_kullanimi/Notlar.dart';
import 'package:notlar_uygulamasi_http_kullanimi/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotDetaySayfa extends StatefulWidget {
  Notlar not;
  NotDetaySayfa({required this.not});

  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState();
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {

  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  Future<void> sil(int not_id) async{
    var url = Uri.parse("http://localhost/web-services-notlar/insert_not.php");
    var veri = {"not_id":not_id.toString()};
    var cevap = await http.post(url, body: veri);
    print("Not Sil cevap : ${cevap.body}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa() ));
  }

  Future<void> guncelle(int not_id, String ders_adi, int not1, int not2) async{
    var url = Uri.parse("http://localhost/web-services-notlar/update_not.php");
    var veri = {"not_id":not_id.toString(), "ders_ad" : ders_adi, "not1":not1.toString(), "not2":not2.toString()};
    var cevap = await http.post(url, body: veri);
    print("Not Güncelle cevap : ${cevap.body}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa() ));
  }

  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfDersAdi.text = not.ders_adi;
    tfNot1.text = not.not1.toString();
    tfNot2.text = not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DERS NOT DETAY"),
        actions: [
          TextButton(
            onPressed: (){
              sil(int.parse(widget.not.not_id));   },
            child: Text("Sil", style: TextStyle(color: Colors.white),),
          ),
          TextButton(
            child: Text("Guncelle", style: TextStyle(color: Colors.white),),
            onPressed: (){
              guncelle(int.parse(widget.not.not_id), tfDersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text) );
            },
          )
        ],
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: InputDecoration(hintText: "Ders Adı"),    ),
              TextField(
                controller: tfNot1,
                decoration: InputDecoration(hintText: "1. Not"),    ),
              TextField(
                controller: tfNot2,
                decoration: InputDecoration(hintText: "2. Not"),    ),
            ],
          ),
        ),
      ),
    );
  }
}
