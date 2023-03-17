import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi_http_kullanimi/NotDetaySayfa.dart';
import 'package:notlar_uygulamasi_http_kullanimi/NotKayitSayfa.dart';
import 'package:notlar_uygulamasi_http_kullanimi/Notlar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notlar_uygulamasi_http_kullanimi/NotlarCevap.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  List<Notlar> parseNotlarCevap(String cevap){
    return NotlarCevap.fromJson(json.decode(cevap)).notlarListesi;
  }

  Future<List<Notlar>> tumNotlarGoster() async{
    var url = Uri.parse("http://localhost/web-services-notlar/tum_notlar.php");
    var cevap = await http.get(url);
    return parseNotlarCevap(cevap.body);
  }

  Future<bool> uygulamayiKapat() async{
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            uygulamayiKapat();
          },
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("DERS NOTLARI UYGULAMASI", style: TextStyle(color: Colors.white, fontSize: 16),),
            FutureBuilder<List<Notlar>>(
              future: tumNotlarGoster(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var notlarListesi = snapshot.data;
                  double ortalama = 0.0;
                  if(!notlarListesi!.isEmpty){
                    double toplam = 0.0;
                    for(var t in notlarListesi){
                      toplam = toplam + (int.parse(t.not1) + int.parse(t.not2))/2;
                    }
                    ortalama = toplam / notlarListesi.length;
                  }
                  return Text("Ortalama : ${ortalama.toInt()}", style: TextStyle(color: Colors.white, fontSize: 14),);
                } else  {
                  return Text("Ortalama : 0", style: TextStyle(color: Colors.white, fontSize: 14),);
                }
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder(
          future: tumNotlarGoster(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              var notlarListesi = snapshot.data;
              return ListView.builder(
                itemCount: notlarListesi!.length,
                itemBuilder: (context, indeks){
                  var not = notlarListesi[indeks];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not,)));
                    },
                    child: Card(
                      child: SizedBox( height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(not.ders_adi, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text((not.not1).toString()),
                            Text((not.not2).toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else  {
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
        },
        tooltip: "Not Ekle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
