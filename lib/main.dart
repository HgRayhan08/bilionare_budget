import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/bottom_navigasi_page.dart';
import 'local_storage/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Keuangan Pribadi',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNavigasiPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}