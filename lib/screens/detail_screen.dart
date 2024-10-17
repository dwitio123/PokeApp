import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../repositories/pokemon_repository.dart';
import 'package:fl_chart/fl_chart.dart';

String capitalizeFirstWord(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class DetailScreen extends StatelessWidget {
  final String pokemonName;

  const DetailScreen(this.pokemonName, {super.key});

  @override
  Widget build(BuildContext context) {
    final repository = PokemonRepository();

    return Scaffold(
      body: FutureBuilder(
        future: repository.fetchPokemonDetail(pokemonName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final pokemon = snapshot.data as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.orange[800],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 90,
                    left: 20,
                    child: Text(
                      capitalizeFirstWord(pokemon['name']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 20,
                    child: Wrap(
                      spacing: 8.0,
                      children: pokemon['types'].map<Widget>((type) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text(
                            capitalizeFirstWord(type['type']['name']),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    top: 310,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pokemon Information
                            const Text(
                              "Information",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                                'Name: ${capitalizeFirstWord(pokemon['name'])}'),
                            Text('Height: ${pokemon['height']} m'),
                            Text('Weight: ${pokemon['weight']} kg'),

                            const SizedBox(height: 20),

                            // Pokemon Stats
                            const Text(
                              "Stats",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: PokemonStatsChart(stats: pokemon['stats']),
                            ),
                            const SizedBox(height: 20),

                            // Abilities
                            const Text(
                              "Abilities",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  pokemon['abilities'].map<Widget>((ability) {
                                return FutureBuilder(
                                  future: repository.fetchAbilityDescription(
                                      ability['ability']['url']),
                                  builder: (context, abilitySnapshot) {
                                    if (abilitySnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (abilitySnapshot.hasData) {
                                      final abilityData = abilitySnapshot.data
                                          as Map<String, dynamic>;
                                      final englishDescription =
                                          abilityData['effect_entries']
                                              .firstWhere((entry) =>
                                                  entry['language']['name'] ==
                                                  'en');
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            capitalizeFirstWord(
                                                ability['ability']['name']),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(englishDescription[
                                              'short_effect']),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    }
                                    return const Text(
                                        "Failed to load ability description");
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPokemonImage(
                            pokemon['sprites']['other']['home']
                                ['front_default'],
                            'Original'),
                        _buildPokemonImage(
                            pokemon['sprites']['other']['dream_world']
                                ['front_default'],
                            'Dream World'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Failed to load Pokémon detail"));
        },
      ),
    );
  }

  Widget _buildPokemonImage(String? imageUrl, String label) {
    return Column(
      children: [
        if (imageUrl != null && imageUrl.endsWith('.svg'))
          SizedBox(
            height: 150,
            width: 150,
            child: SvgPicture.network(
              imageUrl,
              fit: BoxFit.contain,
              placeholderBuilder: (context) =>
                  const CircularProgressIndicator(),
            ),
          )
        else
          Image.network(
            imageUrl ?? '',
            height: 150,
            width: 150,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 150,
                width: 150,
                child: Center(child: Text('No image')),
              );
            },
          ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class PokemonStatsChart extends StatelessWidget {
  final List<dynamic> stats;

  const PokemonStatsChart({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 120,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const titles = ['HP', 'Atk', 'Def', 'Sp.Atk', 'Sp.Def', 'Spd'];
                return Text(
                  titles[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: stats.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value['base_stat'].toDouble(),
                color: Colors.orange[800],
                width: 16,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 120,
                  color: Colors.orange[100],
                ),
              ),
            ],
          );
        }).toList(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 750),
      swapAnimationCurve: Curves.easeInOutQuart,
    );
  }
}
