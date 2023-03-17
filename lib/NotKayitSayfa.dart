import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi_http_kullanimi/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotKayitSayfa extends StatefulWidget {
  @override
  State<NotKayitSayfa> createState() => _NotKayitSayfaState();
}

class _NotKayitSayfaState extends State<NotKayitSayfa> {

  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  Future<void> kayit(String ders_adi, int not1, int not2) async{
    var url = Uri.parse("http://localhost/web-services-notlar/insert_not.php");
    var veri = {"ders_ad" : ders_adi, "not1":not1.toString(), "not2":not2.toString()};
    var cevap = await http.post(url, body: veri);
    print("Not Ekle cevap : ${cevap.body}");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa() ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DERS NOTU KAYDI"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: InputDecoration(hintText: "Ders Adı"),
              ),
              TextField(
                controller: tfNot1,
                decoration: InputDecoration(hintText: "1. Not"),
              ),
              TextField(
                controller: tfNot2,
                decoration: InputDecoration(hintText: "2. Not"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          kayit(tfDersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text));
        },
        tooltip: "Not Kayıt",
        icon: const Icon(Icons.save),
        label: Text("Kaydet"),
      ),
    );
  }
}
