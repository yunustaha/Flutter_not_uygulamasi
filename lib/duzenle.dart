import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/utils/dbhelper.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';

List<Items> _noteList;
int _selectedIndex;

class DuzenkeKisim extends StatefulWidget {
  DuzenkeKisim(getNoteList, getIndex) {
    _noteList = getNoteList;
    _selectedIndex = getIndex;
  }

  @override
  _DuzenkeKisimState createState() => _DuzenkeKisimState();
}

class _DuzenkeKisimState extends State<DuzenkeKisim> {
  //Database için kullanacaklarımız.
  DatabaseHelper dbHelper = DatabaseHelper();
  //Listeleri bu şekilde oluşturmak lazım.

  //İnputlara girilen verilerin değerlerini almak için controller dizisi tanımlıyoruz.
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.yellow[200],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Not Uygulaması",
              style: TextStyle(color: Colors.black),
            ),

            // Kaydet butonu
            TextButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.yellow[200],
              ),
              child: Text(
                "Bitti",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  decoration: TextDecoration.underline,
                ),
              ),
              onPressed: () {
                // Notu ID'si aracılığıyla sql'de bulup verilerini değiştiriyoruz.
                dbHelper.notGuncelle(Items.withId(
                    _noteList[_selectedIndex].id,
                    controllers[0].text,
                    controllers[1].text,
                    //O anki tarih bilgisini almak DateFormat("yyyy-MM-dd").format(DateTime.now()) kullandık.
                    _noteList[_selectedIndex].tarih,
                    _noteList[_selectedIndex].icon));

                //İnputların valuelerini temizledik.
                for (int i = 0; i < controllers.length; i++) {
                  controllers[i].text = "";
                }

                //Notlar sayfasına geri dönüyoruz.
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: listeleme(),
    );
  }

  Widget listeleme() {
    controllers[1].text = _noteList[_selectedIndex].icerik;
    controllers[0].text = _noteList[_selectedIndex].baslik;

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Başlık"),
                maxLength: 26,
                controller: controllers[0],
              ),
              TextField(
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "İçerik"),
                //inputun içine istediğimiz kadar satır oluşturarak yazı yazmamızı sağlıyor.
                keyboardType: TextInputType.multiline,
                maxLines: 25,

                controller: controllers[1],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
