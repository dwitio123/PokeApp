import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../screens/pokemon_list_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pokemon_bloc.dart';
import '../repositories/pokemon_repository.dart';

class PokemonSelector extends StatelessWidget {
  final Pokemon? pokemon;
  final Function(Pokemon) onSelect;

  const PokemonSelector({Key? key, this.pokemon, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedPokemon = await showModalBottomSheet<Pokemon>(
          context: context,
          isScrollControlled: true,
          builder: (context) => BlocProvider(
            create: (context) =>
                PokemonBloc(PokemonRepository())..add(LoadPokemonList()),
            child: const PokemonListDialog(),
          ),
        );
        if (selectedPokemon != null) {
          onSelect(selectedPokemon);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.orange[800],
          ),
          child: pokemon == null
              ? const Text('Select Pokemon',
                  style: TextStyle(color: Colors.white))
              : Column(
                  children: [
                    Image.network(pokemon!.sprites.frontDefault),
                    Text(
                      (pokemon!.name.toUpperCase()),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
