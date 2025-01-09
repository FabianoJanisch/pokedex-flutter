import 'package:flutter/material.dart';
import 'package:pokedex/app/api/pokemons_api.dart';
import 'package:pokedex/app/models/functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    writePokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pokemon.get(1) != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    capitalize(pokemon.get(30)['name']),
                  ),
                ),
              )
            else
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Bulbasaur'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
