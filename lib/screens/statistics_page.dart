import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/models/game_result.dart';
import 'package:intl/intl.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameResultBloc, GameResultsState>(
        builder: (context, state) {
      if (!(state is GameResultsLoadSuccess)) {
        return Text("loading");
      }
      final gameResults = (state as GameResultsLoadSuccess).gameResults
        ..sort((a, b) => b.time.compareTo(a.time));
      return Scaffold(
        appBar: AppBar(
            title: Container(
          child: Text("Statistics"),
        )),
        body: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              StatisticsSectionHeader("Summary"),
              StatisticsSummaryWidget(gameResults),
              SizedBox(
                height: 20,
              ),
              StatisticsSectionHeader("Most Guessed"),
              StatisticsBarChart(gameResults),
              SizedBox(
                height: 20,
              ),
              StatisticsSectionHeader("Game History"),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: gameResults.length,
                  itemBuilder: (context, int index) {
                    return StatisticsListItemWidget(gameResults[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class StatisticsSectionHeader extends StatelessWidget {
  String headerLabel;
  StatisticsSectionHeader(this.headerLabel);
  final TextStyle _headerTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 10),
          Text(
            headerLabel,
            style: _headerTextStyle,
          )
        ],
      ),
    );
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
        height: 130,
        padding: EdgeInsets.all(15),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Games Played",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${gameResults.length}"),
              SizedBox(height: 15),
              Text("Win Rate", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${_getWinRate().toStringAsPrecision(2)}%")
            ],
          ),
          SizedBox(width: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Average Word Length",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${_getAverageDifficulty().toStringAsPrecision(2)}"),
              SizedBox(height: 15),
              Text("Average Guesses",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${_getAverageGuesses().toStringAsPrecision(2)}"),
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

  StatisticsBarChart(this.gameResults);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(15),
      height: 150,
      child: BarChart(
        _getBarChartData(),
      ),
    ));
  }
}

class StatisticsListItemWidget extends StatelessWidget {
  final GameResult gameResult;

  StatisticsListItemWidget(this.gameResult);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: gameResult.didWin ? Colors.green.shade50 : Colors.red.shade50,
        child: Container(
            padding: EdgeInsets.all(15),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Word", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${gameResult.word}"),
                  SizedBox(height: 15),
                  Text("Date",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "${DateFormat.MMMd().format(gameResult.time)}")
                ],
              ),
              SizedBox(width: 45),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guesses",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 35,
                    width: 150,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: gameResult.guesses.characters
                          .map((c) =>
                              Text(c, style: TextStyle(color: gameResult.word.contains(c) ? Colors.green : Colors.red) ))
                          .toList(),
                    ),
                  ),
                  Text("Guesses Used",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      "${gameResult.guesses.characters.where((c) => !gameResult.word.contains(c)).length}/${gameResult.numberOfGuesses}")
                ],
              )
            ])));
  }
}
