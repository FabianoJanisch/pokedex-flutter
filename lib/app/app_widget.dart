
import 'package:flutter/material.dart';
import 'package:pokedex/app/services/pokemon.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Pokedex",
        theme: ThemeData(primarySwatch: Colors.red),
        debugShowCheckedModeBanner: false,
        home: const HomePage2());
  }
}
