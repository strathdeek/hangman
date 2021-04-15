import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hangman/models/game_result.dart';

class StatisticsBarChart extends StatelessWidget {
  final List<GameResult> gameResults;
  final bool displayBarChart;
  BarChartData _getBarChartData() {
    var letterMap = Map<String, int>();
    var letters = <String>[];

    gameResults.forEach((element) {
      var gameLetters = element.guesses.split('').toList();
      letters += gameLetters;
    });

    letters.forEach((letter) {
      if (letterMap.containsKey(letter)) {
        letterMap[letter]++;
      } else {
        letterMap[letter] = 1;
      }
    });
    var uniqueLetters = letterMap.keys.toList();
    uniqueLetters.sort((a, b) => letterMap[b].compareTo(letterMap[a]));

    var groupData = <BarChartGroupData>[];
    for (var i = 0; i < uniqueLetters.length; i++) {
      var rods = <BarChartRodData>[]..add(BarChartRodData(
          y: letterMap[uniqueLetters[i]].toDouble(),
          colors: [Colors.amberAccent],
        ));
      groupData.add(BarChartGroupData(
        x: i + 1,
        barRods: rods,
      ));
    }

    var titles = new FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        getTextStyles: (value) => const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        margin: 16,
        getTitles: (double value) {
          var title = uniqueLetters.elementAt(value.toInt() - 1);
          return title;
        },
      ),
      leftTitles: SideTitles(
        showTitles: false,
      ),
    );
    return BarChartData(
      barGroups: groupData,
      titlesData: titles,
      borderData: FlBorderData(
        show: false,
      ),
    );
  }

  StatisticsBarChart(this.gameResults, this.displayBarChart);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(15),
      child: gameResults.isNotEmpty && displayBarChart
          ? BarChart(
              _getBarChartData(),
            )
          : Container(
              alignment: Alignment.center,
              child: displayBarChart
                  ? Text("No Data")
                  : CircularProgressIndicator(),
            ),
    ));
  }
}
