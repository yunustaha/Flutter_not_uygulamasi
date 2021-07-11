import 'package:flutter_not_uygulamasi/utils/items.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  //sql için tablo ve sütünların isimlerini tanımladık.
  String tableName = "Notlar";
  String colId = "Id";
  String colBaslik = "Baslik";
  String colIcerik = "Icerik";
  String colTarih = "Tarih";
  String colOncelik = "Oncelik";

  // statik constructor'u kullanabilmek için Dbhelper nesnesi tanımladık.
  // böylece tüm sql işlemlerini tek bir class ile yapabileceğiz.
  static final DbHelper _dbHelper = DbHelper._internal();

  // statik default construnctor oluşturduk.
  DbHelper._internal();

  // factory ile return özelliği olan default consturctor tanımladık.
  factory DbHelper() {
    // Oluşturduğumuz Dbhelper nesnesini return ettik.
    return _dbHelper;
  }

  //Database classı sqflite paketinden geliyor.
  static Database _db;

  // Tüm database metodları asenkron olmalıdır! Çünkü bekleme işlemleri olursa program kilitlenmesin.
  // Veri tabanını çağırma metodu.
  Future<Database> get db async {
    if (_db = null) {
      //await özelliğini kullanacağımız metod async olmalı!
      _db = await initializeDb();
      return _db;
    }
    return _db;
  }

  // Veri tabanını oluşturma metodu.
  Future<Database> initializeDb() async {
    // Veri tabanımızın olduğu klasöre gittik. (İos ev android'te).
    // getApplicationDocumentsDirectory() path_provider paketinden geldi.
    Directory directory = await getApplicationDocumentsDirectory();
    // Veri tabanı dosyasının yolunu ve ismini tanımladık.
    String path = directory.path + "Notdata.db";

    // database tablolarını oluşturduk.
    var dbNotlardata =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return dbNotlardata;
  }

  // tablo oluşturma komutlarını Sql'e gönderdik.
  void _createDb(Database db, int version) async {
    await db.execute(
        "Create table $tableName($colId integer primary key, $colBaslik text, $colIcerik text, $colTarih text, $colOncelik integer)");
  }

  // Items class'ında oluşturduğumuz verileri map şeklinde göndererek Tabloya ekleme metodu.

  // metod işlemden etkilenen Id'yi döndürdüğü için Future<int> ile tanımaldık.
  Future<int> insert(Items items) async {
    // Database'ye ulaştık. (this.db yukarda get ile oluşturduğumuz db).
    Database db = await this.db;

    var result = await db.insert(tableName, items.toMap());
    return result;
  }

  // Tabloda veri güncelleme metodu.
  Future<int> update(Items items) async {
    // Database'ye ulaştık. (this.db yukarda get ile oluşturduğumuz db).
    Database db = await this.db;

    var result = await db.update(tableName, items.toMap(),
        // "$colId = ?" --> = ? ben bir colId gönderecem demek. bu Id'yi whereArgs: [items.id] ile gönderdik.
        where: "$colId = ?",
        whereArgs: [items.id]);
    return result;
  }

  // Tabloda veri silme metodu.
  // Id primary key olduğundan onu sildiğimiz zaman o satır da silinir.
  Future<int> delete(int id) async {
    // Database'ye ulaştık. (this.db yukarda get ile oluşturduğumuz db).
    Database db = await this.db;

    //rawDelete vb. ile direkt sql'e sql kodu gönderiyoruz.
    var result =
        await db.rawDelete("Delete from $tableName where $colId = $id");
    return result;
  }

  // Tablodaki verilere erişme metodu.
  // List donderdiği için Future<List> kullandık.
  Future<List> getItems() async {
    // Database'ye ulaştık. (this.db yukarda get ile oluşturduğumuz db).
    Database db = await this.db;

    //rawdQuery vb. ile direkt sql'e sql kodu gönderiyoruz.
    var result = await db.rawQuery("Select * from $tableName");
    return result;
  }
}
