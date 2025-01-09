import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

final pokemon = Hive.box('pokemon');

Future<void> writePokemon() async {
  const baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  for (var i = 1; i <= 30; i++) {
    // Verifica se o Pokémon já está armazenado
    if (!pokemon.containsKey(i)) {
      final url = '$baseUrl$i/';
      final response = await http.get(Uri.parse(url));
      final dataPokemon = jsonDecode(response.body);

      // Armazena o Pokémon no Hive
      pokemon.put(i, {
        'name': dataPokemon['name'],
        'type': dataPokemon['types'],
        'sprite': dataPokemon['sprites']['other']['home']['front_default']
      });
    }
  }
}
