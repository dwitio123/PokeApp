import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/pokemon_repository.dart';

// Events
abstract class PokemonEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPokemonList extends PokemonEvent {}

class LoadMorePokemon extends PokemonEvent {}

// States
abstract class PokemonState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonLoading extends PokemonState {}

class PokemonLoadingMore extends PokemonState {
  final List<dynamic> pokemonList;
  PokemonLoadingMore(this.pokemonList);

  @override
  List<Object> get props => [pokemonList];
}

class PokemonLoaded extends PokemonState {
  final List<dynamic> pokemonList;
  PokemonLoaded(this.pokemonList);

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonError extends PokemonState {
  final String message;
  PokemonError([this.message = "Failed to load Pokémon data"]);

  @override
  List<Object?> get props => [message];
}

// Bloc
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonRepository repository;
  int _offset = 0;
  final int _limit = 25;

  PokemonBloc(this.repository) : super(PokemonLoading()) {
    on<LoadPokemonList>((event, emit) async {
      emit(PokemonLoading());
      try {
        final pokemonList = await repository.fetchPokemonList(_offset, _limit);
        _offset += _limit;
        emit(PokemonLoaded(pokemonList));
      } catch (e) {
        emit(PokemonError("Failed to load initial Pokémon list"));
      }
    });

    on<LoadMorePokemon>((event, emit) async {
      if (state is PokemonLoaded) {
        final currentPokemonList = (state as PokemonLoaded).pokemonList;
        emit(PokemonLoadingMore(currentPokemonList));
        try {
          final newPokemonList =
              await repository.fetchPokemonList(_offset, _limit);

          if (newPokemonList.isNotEmpty) {
            _offset += _limit;
            emit(PokemonLoaded(currentPokemonList + newPokemonList));
          } else {
            emit(PokemonError("No more Pokémon to load"));
          }
        } catch (e) {
          emit(PokemonError("Failed to load more Pokémon"));
        }
      }
    });
  }
}
