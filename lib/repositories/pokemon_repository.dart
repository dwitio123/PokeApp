import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonRepository {
  final String baseUrl = "https://pokeapi.co/api/v2/";

  Future<List<dynamic>> fetchPokemonList(int offset, int limit) async {
    final response = await http
        .get(Uri.parse("$baseUrl/pokemon?offset=$offset&limit=$limit"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> pokemonList = data['results'];

      List<dynamic> detailedPokemonList =
          await Future.wait(pokemonList.map((pokemon) async {
        final detailResponse = await http.get(Uri.parse(pokemon['url']));
        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          return {
            'name': pokemon['name'],
            'sprites': detailData['sprites']['other']['home']['front_default']
          };
        }
        return null;
      }));

      return detailedPokemonList.where((pokemon) => pokemon != null).toList();
    } else {
      throw Exception("Failed to load Pokémon list");
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetail(String name) async {
    final response = await http.get(Uri.parse("$baseUrl/pokemon/$name"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load Pokemon detail");
    }
  }

  Future<Map<String, dynamic>> fetchAbilityDescription(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ability description');
    }
  }
}
