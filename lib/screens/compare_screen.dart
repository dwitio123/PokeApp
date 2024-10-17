import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../widgets/pokemon_selector.dart';
import '../widgets/comparison_chart.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({Key? key}) : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Pokemon? pokemon1;
  Pokemon? pokemon2;

  void _selectPokemon(int selectorIndex, Pokemon selectedPokemon) {
    setState(() {
      if (selectorIndex == 1) {
        pokemon1 = selectedPokemon;
      } else {
        pokemon2 = selectedPokemon;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PokeApp - Dwitio Ahmad Pranoto')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: PokemonSelector(
                    pokemon: pokemon1,
                    onSelect: (pokemon) => _selectPokemon(1, pokemon),
                  ),
                ),
                Expanded(
                  child: PokemonSelector(
                    pokemon: pokemon2,
                    onSelect: (pokemon) => _selectPokemon(2, pokemon),
                  ),
                ),
              ],
            ),
          ),
          if (pokemon1 != null && pokemon2 != null)
            Expanded(
              child: ComparisonChart(pokemon1: pokemon1!, pokemon2: pokemon2!),
            ),
        ],
      ),
    );
  }
}
