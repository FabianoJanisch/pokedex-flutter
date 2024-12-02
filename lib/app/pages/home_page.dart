import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> allNamePokemons() async {
    var url =
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0');
    var response = await http.get(url); // Requisita ao site

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data[
          'results']; // A API Pokémon retorna uma chave 'results' contendo os dados dos Pokémon
    } else {
      throw Exception('Erro ao carregar os dados do servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: allNamePokemons(),
        builder: (context, snapshot) {
          // Se tiver dados
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 30, //snapshot.data!.length,
              itemBuilder: (context, index) {
                var pokemon = snapshot.data![index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text(capitalize(pokemon['name'].toString())),
                );
              },
            );
          }

          // Tratar erro
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os dados'),
            );
          }

          // Carregando site
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
