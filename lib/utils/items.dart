// Model nesnesi oluşturduk.
class Items {
  int _id;
  String _baslik;
  String _icerik;
  String _tarih;
  int _icon;

  // Default constructor ile alınan verileri değişkenlere eşitledik.
  Items(this._baslik, this._icerik, this._tarih, this._icon);

  Items.withId(this._id, this._baslik, this._icerik, this._tarih, this._icon);

  // get edebileceğimiz verileri yazdık.
  int get id => _id;
  String get baslik => _baslik;
  String get icerik => _icerik;
  String get tarih => _tarih;
  int get icon => _icon;

  //Verileri map'a çevirip döndüren metod.
  Map<String, dynamic> toMap() {
    // map adında bir HashMap oluşturduk.
    var map = Map<String, dynamic>();

    // verileri map'a aktardık.
    map["notBaslik"] = _baslik;
    map["notIcerik"] = _icerik;
    map["notTarih"] = _tarih;
    map["notIcon"] = _icon;

    return map;
  }

  // Verileri Sql'den getirip Items listesine atarken kullanacağımız metod.
  Items.fromMap(Map<String, dynamic> map) {
    this._id = map["notID"];
    this._baslik = map["notBaslik"];
    this._icerik = map["notIcerik"];
    this._tarih = map["notTarih"];
    this._icon = map["notIcon"];
  }
}
