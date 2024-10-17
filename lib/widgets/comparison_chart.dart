import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pokemon.dart';

class ComparisonChart extends StatelessWidget {
  final Pokemon pokemon1;
  final Pokemon pokemon2;

  const ComparisonChart(
      {super.key, required this.pokemon1, required this.pokemon2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
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
                  const titles = [
                    'HP',
                    'Atk',
                    'Def',
                    'Sp.Atk',
                    'Sp.Def',
                    'Spd'
                  ];
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
          barGroups: [
            _createBarGroup(
                0, pokemon1.stats[0].baseStat, pokemon2.stats[0].baseStat),
            _createBarGroup(
                1, pokemon1.stats[1].baseStat, pokemon2.stats[1].baseStat),
            _createBarGroup(
                2, pokemon1.stats[2].baseStat, pokemon2.stats[2].baseStat),
            _createBarGroup(
                3, pokemon1.stats[3].baseStat, pokemon2.stats[3].baseStat),
            _createBarGroup(
                4, pokemon1.stats[4].baseStat, pokemon2.stats[4].baseStat),
            _createBarGroup(
                5, pokemon1.stats[5].baseStat, pokemon2.stats[5].baseStat),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 750),
        swapAnimationCurve: Curves.easeInOutQuart,
      ),
    );
  }

  BarChartGroupData _createBarGroup(int x, int y1, int y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1.toDouble(),
          color: Colors.blue,
          width: 16,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 120,
            color: Colors.blue.withOpacity(0.1),
          ),
        ),
        BarChartRodData(
          toY: y2.toDouble(),
          color: Colors.red,
          width: 16,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 120,
            color: Colors.red.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
