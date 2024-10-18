import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/pokemon_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<PokemonBloc>().add(LoadMorePokemon());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeApp - Dwitio Ahmad Pranoto'),
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PokemonLoaded || state is PokemonLoadingMore) {
            final pokemonList = state is PokemonLoaded
                ? state.pokemonList
                : (state as PokemonLoadingMore).pokemonList;
            final isLoadingMore = state is PokemonLoadingMore;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                controller: scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: pokemon['name'],
                        );
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
                              Flexible(
                                child: Text(
                                  pokemon['name'].toString().toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (isLoadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return null;
                },
              ),
            );
          } else if (state is PokemonError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          return const Center(child: Text("Unknown error occurred"));
        },
      ),
    );
  }
}
