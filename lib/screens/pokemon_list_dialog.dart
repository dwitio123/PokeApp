import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pokemon_bloc.dart';
import '../models/pokemon.dart';
import '../repositories/pokemon_repository.dart';

class PokemonListDialog extends StatelessWidget {
  const PokemonListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<PokemonBloc>().add(LoadMorePokemon());
      }
    });

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose Pokemon',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                if (state is PokemonLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PokemonLoaded ||
                    state is PokemonLoadingMore) {
                  final pokemonList = state is PokemonLoaded
                      ? state.pokemonList
                      : (state as PokemonLoadingMore).pokemonList;
                  final isLoadingMore = state is PokemonLoadingMore;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4 / 3,
                      ),
                      itemCount: pokemonList.length + (isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < pokemonList.length) {
                          final pokemon = pokemonList[index];
                          final imageUrl = pokemon['sprites'];

                          return GestureDetector(
                            onTap: () async {
                              final pokemonRepository = PokemonRepository();
                              try {
                                final pokemonDetail = await pokemonRepository
                                    .fetchPokemonDetail(pokemon['name']);
                                final selectedPokemon = Pokemon(
                                  name: pokemonDetail['name'],
                                  sprites: Sprites(
                                      frontDefault: pokemonDetail['sprites']
                                          ['other']['home']['front_default']),
                                  stats: (pokemonDetail['stats'] as List)
                                      .map((stat) =>
                                          Stat(baseStat: stat['base_stat']))
                                      .toList(),
                                );
                                Navigator.of(context).pop(selectedPokemon);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Failed to load Pokemon details: $e')),
                                );
                              }
                            },
                            child: Card(
                              color: Colors.orange[800],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      pokemon['name'].toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (isLoadingMore) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return null;
                      },
                    ),
                  );
                } else if (state is PokemonError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
