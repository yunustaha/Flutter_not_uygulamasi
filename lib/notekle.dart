import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/utils/dbhelper.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';
import 'package:intl/intl.dart';

class NotEkle extends StatefulWidget {
  @override
  _NotEkleState createState() => _NotEkleState();
}

class _NotEkleState extends State<NotEkle> {
  final formKey = GlobalKey<FormState>();

  String _baslik;
  String _icerik;

  //Database için kullanacaklarımız.
  DatabaseHelper dbHelper = DatabaseHelper();

  bool _girisBilgileriniOnayla() {
    // Eğer validate kısmında hata olmamışsa true döner.
    if (formKey.currentState.validate()) {
      //Formun o anki değerlerini kaydettik
      formKey.currentState.save();
      // O anki tarih bilgisini almak DateFormat("yyyy-MM-dd").format(DateTime.now()) kullandık.
      dbHelper.notEkle(Items(_baslik, _icerik,
          DateFormat("yyyy-MM-dd").format(DateTime.now()), 1));

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.yellow[300],
        title: Text(
          "Not Uygulaması",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),

          //Scroll özelliği kazazdırdık
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 50),

              // Form oluşturduk.
              child: Form(
                //Yukarda oluşturduğumuz keyi tanımladık.
                key: formKey,
                //validator'lerin ilk başta otomatik kontrol edilmesini sağladık.
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Not bilgilerini giriniz",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      height: 45,
                    ),

                    // İnput
                    TextFormField(
                      // İnputun dekorasyonunu yaptık.
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        labelText: "Başlık",
                        border: OutlineInputBorder(),
                      ),

                      // Boşluk girildiğinde hata mesajı verecek.
                      validator: (String girilenVeri) {
                        if (girilenVeri == " " || girilenVeri.length < 1) {
                          return "Lütfen bir başlık girin. ";
                        } else
                          return null;
                      },
                      //Kaydedildiğinde inputtaki veriyi yukarda tanımladığımız değişkene eşitliyecek.
                      onSaved: (deger) => _baslik = deger,
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    // input
                    TextFormField(
                      // İnputun dekorasyonunu yaptık.
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.notes,
                        ),
                        labelText: "Not içerik",
                        border: OutlineInputBorder(),
                      ),

                      // Boşluk girildiğinde hata mesajı verecek.
                      validator: (String girilenVeri) {
                        if (girilenVeri == " " || girilenVeri.length < 1) {
                          return "Lütfen bir not girin. ";
                        } else
                          return null;
                      },

                      //Kaydedildiğinde inputtaki veriyi yukarda tanımladığımız değişkene eşitliyecek.
                      onSaved: (deger) => _icerik = deger,
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    // Oluştur butonu
                    TextButton(
                      onPressed: () {
                        // _girisBilgileriniOnayla() ile inputlardaki verileri sql'e kaydediyoruz.
                        if (_girisBilgileriniOnayla() == true) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Harika!"),
                                content: new Text(
                                    "Notunuz başarılı bir şekilde kaydedildi!"),
                                actions: <Widget>[
                                  new ElevatedButton(
                                    child: new Text("Tamam"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        //Herhangi bir sorunda gösterilecek hata mesajı.
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Üzgünüm :("),
                                content: new Text(
                                    "Beklenmedik bir sorun ortaya çıktı!"),
                                actions: <Widget>[
                                  new ElevatedButton(
                                    child: new Text("Tamam"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            " Oluştur",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
