import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/utils/dbhelper.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';
import 'package:intl/intl.dart';

// Sql'e gönderilecek icon rakamı.
int _icon = 0;

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
          DateFormat("yyyy-MM-dd").format(DateTime.now()), _icon));

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            //Sayfaya geri geldiğimizde 0. icon seçili gözükecek bu yüzden Seçilen icon değerini sıfırladık.
            _icon = 0;
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.yellow[300],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Not Uygulaması",
              style: TextStyle(color: Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Oluştur butonu
                TextButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.yellow[300],
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.black87,
                    size: 40,
                  ),
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
                            content:
                                new Text("Beklenmedik bir sorun ortaya çıktı!"),
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
                ),
              ],
            ),
          ],
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
                    // İcon seçme listesi
                    ToogleButton(),

                    SizedBox(
                      height: 30,
                    ),

                    // İnput
                    TextFormField(
                      //maksimum harf sayısı.
                      maxLength: 26,
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
                      //maksimum harf sayısı.
                      maxLength: 256,

                      //inputun içine istediğimiz kadar satır oluşturarak yazı yazmamızı sağlıyor.
                      keyboardType: TextInputType.multiline,
                      maxLines: null,

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
                      height: 17,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

// Togge button widget'i
// ignore: must_be_immutable
class ToogleButton extends StatefulWidget {
  @override
  _ToogleButtonState createState() => _ToogleButtonState();
}

class _ToogleButtonState extends State<ToogleButton> {
  var _isSelected = <bool>[true, false, false, false, false];
  var _iconName = <int>[0, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.black.withOpacity(0.60),
      selectedColor: Colors.blueAccent,
      selectedBorderColor: Colors.blueAccent,
      fillColor: Colors.blueAccent.withOpacity(0.08),
      splashColor: Colors.blueAccent.withOpacity(0.12),
      hoverColor: Colors.blueAccent.withOpacity(0.04),
      borderRadius: BorderRadius.circular(4.0),
      isSelected: _isSelected,
      onPressed: (index) {
        // Respond to button selection
        setState(() {
          _isSelected = [false, false, false, false, false];
          _isSelected[index] = !_isSelected[index];
          //Seçilen iconu sql'e göndereceğimiz değişkene eşitledik.
          _icon = _iconName[index];
        });
      },
      children: [
        Container(
            width: (MediaQuery.of(context).size.width - 56) / 5,
            child: Icon(Icons.event_note_outlined)),
        Container(
            width: (MediaQuery.of(context).size.width - 56) / 5,
            child: Icon(Icons.notifications)),
        Container(
            width: (MediaQuery.of(context).size.width - 56) / 5,
            child: Icon(Icons.access_alarm)),
        Container(
            width: (MediaQuery.of(context).size.width - 56) / 5,
            child: Icon(Icons.favorite)),
        Container(
            width: (MediaQuery.of(context).size.width - 56) / 5,
            child: Icon(Icons.visibility)),
      ],
    );
  }
}
