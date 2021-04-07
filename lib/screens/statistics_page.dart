import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/models/game_result.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameResultBloc, GameResultsState>(
        builder: (context, state) {
      if (!(state is GameResultsLoadSuccess)) {
        return Text("loading");
      }
      final gameResults = (state as GameResultsLoadSuccess).gameResults;
      return Scaffold(
        appBar: AppBar(
            title: Container(
          child: Text("Statistics"),
        )),
        body: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              StatisticsSummaryWidget(gameResults),
              SizedBox(
                height: 40,
              ),
              StatisticsBarChart(gameResults),
              SizedBox(
                height: 40,
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: gameResults.length,
                itemBuilder: (context, int index) {
                  return StatisticsListItemWidget(gameResults[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class StatisticsSummaryWidget extends StatelessWidget {
  final List<GameResult> gameResults;

  StatisticsSummaryWidget(this.gameResults);

  double _getWinRate() {
    var totalWins = gameResults.where((game) => game.didWin).length;
    return totalWins / gameResults.length;
  }

  double _getAverageDifficulty() {
    var lengths = gameResults.map((e) => e.word.length);
    var sumOfLengths = lengths.reduce((value, element) => value + element);
    return sumOfLengths / gameResults.length;
  }

  double _getAverageGuesses() {
    var guesses = gameResults.map((e) => e.numberOfGuesses);
    var sumOfLengths = guesses.reduce((value, element) => value + element);
    return sumOfLengths / gameResults.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Games Played",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${gameResults.length}"),
              Text("Win Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${_getWinRate()}%")
            ],
          ),
          SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Average Word Length",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_getAverageDifficulty()}"),
              Text("Average Guesses",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${_getAverageGuesses()}"),
            ],
          )
        ]),
      ),
    );
  }
}

class StatisticsBarChart extends StatelessWidget {
  final List<GameResult> gameResults;

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
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            var title = uniqueLetters.elementAt(value.toInt() - 1);
            print("index: $value, title: $title");
            return title;
          },
        ));
    return BarChartData(barGroups: groupData, titlesData: titles);
  }

  StatisticsBarChart(this.gameResults);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      height: 200,
      child: BarChart(_getBarChartData()),
    ));
  }
}

class StatisticsListItemWidget extends StatelessWidget {
  final GameResult gameResult;

  StatisticsListItemWidget(this.gameResult);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("Word: ${gameResult.word}"));
  }
}
