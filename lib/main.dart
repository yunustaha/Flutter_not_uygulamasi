import 'package:flutter/material.dart';
import 'package:flutter_not_uygulamasi/giris.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Debug simgesini kaldırır
      debugShowCheckedModeBanner: false,
      home: GovdeKisim(),
    );
  }
}
