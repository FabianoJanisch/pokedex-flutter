import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Classe PokemonClass
class PokemonClass {
  final String name;
  final String image;

  PokemonClass({required this.name, required this.image});

  // Método para criar uma instância a partir de um JSON
  factory PokemonClass.fromJson(Map<String, dynamic> json) {
    return PokemonClass(
      name: json['name'],
      image: json['sprites']['front_default'] ?? '',
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final List<PokemonClass> _pokemons = [];
  int _currentIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPokemonsBatch(1, 10); // Carregar os primeiros 10 Pokémon
  }

  Future<void> _fetchPokemonsBatch(int start, int count) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      List<Future<PokemonClass>> requests = [];
      for (int id = start; id < start + count; id++) {
        var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
        requests.add(http.get(url).then((response) {
          if (response.statusCode == 200) {
            var json = jsonDecode(response.body);
            return PokemonClass.fromJson(json);
          } else {
            throw Exception('Erro ao carregar o Pokémon $id');
          }
        }));
      }

      List<PokemonClass> newPokemons = await Future.wait(requests);
      setState(() {
        _pokemons.addAll(newPokemons);
      });
    } catch (e) {
      print('Erro ao carregar os Pokémon: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showNextPokemon() {
    if (_currentIndex == _pokemons.length - 1) {
      _fetchPokemonsBatch(_pokemons.length + 1, 10); // Carregar mais 10 Pokémon
    }
    if (_currentIndex < _pokemons.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _showPreviousPokemon() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Center(
        child: _pokemons.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _pokemons[_currentIndex].name.capitalize(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _pokemons[_currentIndex].image.isNotEmpty
                              ? Image.network(
                                  _pokemons[_currentIndex].image,
                                  height: 150,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.image_not_supported,
                                  size: 150),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _currentIndex > 0 ? _showPreviousPokemon : null,
                        child: const Text('Anterior'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: !_isLoading ? _showNextPokemon : null,
                        child: const Text('Próximo'),
                      ),
                    ],
                  ),
                ],
              )
            : _isLoading
                ? const CircularProgressIndicator()
                : const Text('Nenhum Pokémon carregado.'),
      ),
    );
  }
}

// Extensão para capitalizar strings
extension StringCapitalization on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
