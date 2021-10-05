import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/duzenle.dart';
import 'package:flutter_not_uygulamasi/kategori.dart';
import 'package:flutter_not_uygulamasi/notekle.dart';
import 'package:flutter_not_uygulamasi/utils/dbhelper.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';

class GovdeKisim extends StatefulWidget {
  @override
  _GovdeKisimState createState() => _GovdeKisimState();
}

class _GovdeKisimState extends State<GovdeKisim> {
  // Sql'den gelen rakama göre oluşturulacak nottaki iconların listesi.
  List<Widget> _iconsForSql = [
    Icon(
      Icons.event_note_outlined,
      size: 30,
    ),
    Icon(
      Icons.notifications,
      size: 30,
    ),
    Icon(
      Icons.access_alarm,
      size: 30,
    ),
    Icon(
      Icons.favorite,
      size: 30,
    ),
    Icon(
      Icons.visibility,
      size: 30,
    ),
  ];

  //Database için kullanacaklarımız.
  DatabaseHelper dbHelper = DatabaseHelper();
  //Listeleri bu şekilde oluşturmak lazım.
  //Gelen tüm dataları Items nesnesi olarak bu listeye atacağız.
  List<Items> tumNotlar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Colors.yellow[200],
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Not Uygulaması",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.yellow[200],
                  ),
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
                    size: 40,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(child: KategoriKisim()),
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

    //Reorderable yani yeniden sıralanabilir listeler oluşturduk.
    return ReorderableListView.builder(
      // Çağırılacak not sayısı.
      itemCount: tumNotlar.length,
      // Notlar index numaralarına göre sırasıyla getirildi.
      itemBuilder: (context, index) {
        final int productName = tumNotlar[index].id;
        return Card(
          //onReorder: için key tanımlamamız gerekiyor bu yüzden id'leri key olarak tanımladık.
          key: ValueKey(productName),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 6.7,
                padding: EdgeInsets.only(
                  left: 10,
                ),
                child: Column(
                  children: [
                    // Alt kısımlardaki tarih ve düzenle, sil buttonları.
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              tumNotlar[index].tarih,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),

                            //Silme butonu.

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 25,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
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
                                                dbHelper.notSil(
                                                    tumNotlar[index].id);

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
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Tıklandiğinda NotEkle sayfasına yönlendirdik.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DuzenkeKisim(tumNotlar, index)),
                        );
                      },
                      child: ListTile(
                        //Datadan çektiğimiz rakama göre icon belirledik.
                        leading: _iconsForSql[tumNotlar[index].icon],
                        // Data listesinden başlığı çektik.
                        title: Text(
                          tumNotlar[index].baslik,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),

                        // Data listesinden içeriği çektik.
                        subtitle:
                            // Devamıno oku işareti için pupbspec.yaml'a package ekledik.
                            Text(
                          tumNotlar[index].icerik,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },

      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          //Yerleri değiştirilen notların Id'lerini değiştirip sql'e kaydediyoruz.
          Items _selectedItem = tumNotlar[oldIndex];
          debugPrint(
              "newIndex : $newIndex, oldIndex : $oldIndex, oldItemId : ${tumNotlar[oldIndex].id}, newItemId : ${tumNotlar[newIndex].id}");
          if (tumNotlar[oldIndex].id > tumNotlar[newIndex].id) {
            for (int i = newIndex; i > oldIndex; i--) {
              dbHelper.notGuncelle(
                Items.withId(tumNotlar[i - 1].id, tumNotlar[i].baslik,
                    tumNotlar[i].icerik, tumNotlar[i].tarih, tumNotlar[i].icon),
              );
              dbHelper.notGuncelle(Items.withId(
                  tumNotlar[newIndex].id,
                  _selectedItem.baslik,
                  _selectedItem.icerik,
                  _selectedItem.tarih,
                  _selectedItem.icon));
            }
          } else if (tumNotlar[oldIndex].id < tumNotlar[newIndex].id) {
            for (int i = oldIndex; i > newIndex; i--) {
              dbHelper.notGuncelle(
                Items.withId(
                    tumNotlar[i].id,
                    tumNotlar[i - 1].baslik,
                    tumNotlar[i - 1].icerik,
                    tumNotlar[i - 1].tarih,
                    tumNotlar[i - 1].icon),
              );
              dbHelper.notGuncelle(Items.withId(
                  tumNotlar[newIndex].id,
                  _selectedItem.baslik,
                  _selectedItem.icerik,
                  _selectedItem.tarih,
                  _selectedItem.icon));
            }
          }

          //Tumnotlar listesini güncelliyoruz
          final item = tumNotlar.removeAt(oldIndex);
          tumNotlar.insert(newIndex, item);
        });
      },
    );
  }
}
