// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pokedex/app/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('pokemon');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
