import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/notekle.dart';
import 'package:flutter_not_uygulamasi/utils/dbhelper.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';
import 'package:intl/intl.dart';

class GovdeKisim extends StatefulWidget {
  @override
  _GovdeKisimState createState() => _GovdeKisimState();
}

class _GovdeKisimState extends State<GovdeKisim> {
  //Database için kullanacaklarımız.
  DatabaseHelper dbHelper = DatabaseHelper();
  //Listeleri bu şekilde oluşturmak lazım.
  //Gelen tüm dataları Items nesnesi olarak bu listeye atacağız.
  List<Items> tumNotlar = [];

  //İnputlara girilen verilerin değerlerini almak için controller dizisi tanımlıyoruz.
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.yellow[300],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Not Uygulaması",
              style: TextStyle(color: Colors.black),
            ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[300],
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    // Tıklandiğinda NotEkle sayfasına yönlendirdik.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotEkle()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black87,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: listeleme(),
    );
  }

  Widget listeleme() {
    //Tüm dataları tumNotlar listesine attık.
    dbHelper.notListesiniGetir().then((value) {
      // Sayfaya geri dönüldüğünde setState ile değişim olduğunu bildiriyoruz ve notlar dinamik olarak listeleniyor.
      setState(() {});
      tumNotlar = value;
    });
    return ListView.builder(
        // Çağırılacak not sayısı.
        itemCount: tumNotlar.length,
        // Notlar index numaralarına göre sırasıyla getirildi.
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      //İconumuz
                      Icons.event_note_outlined,
                      size: 35,
                    ),
                    // Data listesinden başlığı çektik.
                    title: Text(
                      tumNotlar[index].baslik,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                    ),

                    // Data listesinden içeriği çektik.
                    subtitle: Text(
                      tumNotlar[index].icerik,
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),

                // Alt kısımlardaki tarih ve düzenle, sil buttonları.
                Container(
                  margin: EdgeInsets.only(left: 10, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        tumNotlar[index].tarih,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Row(
                        children: <Widget>[
                          // Düzenleme ve silme buttonunun olduğu kısımlar.
                          //Düzenle buttonu.
                          TextButton(
                            child: const Text(
                              'Düzenle',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 16),
                            ),
                            onPressed: () {
                              //Düzenleme için uyarı kutucuğu.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Dikkat!! \nDüzenleme yapıyorsunuz."),
                                    content: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: "Başlık"),
                                            controller: controllers[0],
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: "İçerik"),
                                            controller: controllers[1],
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blueAccent,
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            child: Text("Değiştir"),
                                            onPressed: () {
                                              // Notu ID'si aracılığıyla sql'de bulup verilerini değiştiriyoruz.
                                              dbHelper.notGuncelle(Items.withId(
                                                  tumNotlar[index].id,
                                                  controllers[0].text,
                                                  controllers[1].text,
                                                  //O anki tarih bilgisini almak DateFormat("yyyy-MM-dd").format(DateTime.now()) kullandık.
                                                  DateFormat("yyyy-MM-dd")
                                                      .format(DateTime.now()),
                                                  1));

                                              //İnputların valuelerini temizledik.
                                              for (int i = 0;
                                                  i < controllers.length;
                                                  i++) {
                                                controllers[i].text = "";
                                              }

                                              //AlertDialog'u kapatıp Bulunduğumuz sayfaya geri dönüyoruz.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            child: Text("İptal"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          //Silme buttonu.
                          TextButton(
                            child: const Text(
                              'Sil',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            onPressed: () {
                              //Silme için uyarı kutucuğu.
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text("Dikkat!"),
                                    content: new Text(
                                        "Bu notu gerçekten silmek istiyor musunuz ?"),
                                    actions: <Widget>[
                                      Row(
                                        children: [
                                          new ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            child: new Text("Sil"),
                                            onPressed: () {
                                              //Notları silmek için tumNotlar listesinin o anki index'indeki sınıfının id verisini çağırdık.
                                              dbHelper
                                                  .notSil(tumNotlar[index].id);

                                              //AlertDialog'u kapatıp Bulunduğumuz sayfaya geri dönüyoruz.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          new ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                textStyle: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            child: new Text("İptal"),
                                            onPressed: () {
                                              //AlertDialog'u kapatıp Bulunduğumuz sayfaya geri dönüyoruz.
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
