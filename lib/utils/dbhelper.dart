import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_not_uygulamasi/utils/items.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // statik constructor'u kullanabilmek için Dbhelper nesnesi tanımladık.
  // böylece tüm sql işlemlerini tek bir class ile yapabileceğiz.
  static DatabaseHelper _databaseHelper;

  //Database classı sqflite paketinden geliyor.
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

// Oluşturduğumuz veri tabanı dosyasını kopyalayarak işletim sistemine göre oluşturduk.
// Database dosyasını oluşturduk.
  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlar.db");

    // Check if the database exists
    // Database dosyası var mı kontrol ettik. exists boolean bir değer alacak.
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Asset'deki dosyadan yeni kopya oluşturma.");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      // Bu dosyayı kopyalayıp işletim sistemine göre oluşturacak.
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Mevcut veritabanını açma.");
    }
    // open the database
    // Database'yi açma kısmı.
    return await openDatabase(path, readOnly: false);
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery('select * from "not" order by notID Desc;');
    return sonuc;
  }

  // Notları direkt liste halinde getirmek için yazılan metod.
  Future<List<Items>> notListesiniGetir() async {
    print("Not listesi getirildi.");
    var notlarMapListesi = await notlariGetir();
    //Listeleri bu şekilde oluşturmak lazım.
    List<Items> notListesi = [];
    // Sırasıyla Sql'e kayıtlı tüm veri gruplarını map şeklinde döndürdük ve Items nesnesi olarak notListesi listesine ekledik.
    // Böylece tüm datayı liste halinde göndermiş olduk.
    for (Map map in notlarMapListesi) {
      notListesi.add(Items.fromMap(map));
    }
    return notListesi;
  }

  Future<int> notEkle(Items not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("not", not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Items not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update("not", not.toMap(), where: 'notID = ?', whereArgs: [not.id]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("not", where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }
}
