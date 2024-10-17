class Pokemon {
  final String name;
  final Sprites sprites;
  final List<Stat> stats;

  Pokemon({
    required this.name,
    required this.sprites,
    required this.stats,
  });
}

class Sprites {
  final String frontDefault;

  Sprites({required this.frontDefault});
}

class Stat {
  final int baseStat;

  Stat({required this.baseStat});
}
