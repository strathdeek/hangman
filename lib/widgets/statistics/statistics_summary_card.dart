import 'package:flutter/material.dart';
import 'package:hangman/models/game_result.dart';

class StatisticsSummaryCard extends StatelessWidget {
  final List<GameResult> gameResults;
  final bool showSummary;

  StatisticsSummaryCard(this.gameResults, this.showSummary);

  String _getWinRate() {
    if (gameResults.isEmpty) {
      return "-";
    }
    var totalWins = gameResults.where((game) => game.didWin).length;
    var winRate = totalWins / gameResults.length;
    return "${winRate.toStringAsPrecision(2)}%";
  }

  String _getAverageDifficulty() {
    if (gameResults.isEmpty) {
      return "-";
    }
    var lengths = gameResults.map((e) => e.word.length);
    var sumOfLengths = lengths.reduce((value, element) => value + element);
    return (sumOfLengths / gameResults.length).toStringAsPrecision(2);
  }

  String _getAverageGuesses() {
    if (gameResults.isEmpty) {
      return "-";
    }
    var guesses = gameResults.map((e) => e.numberOfGuesses);
    var sumOfLengths = guesses.reduce((value, element) => value + element);
    return (sumOfLengths / gameResults.length).toStringAsPrecision(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: showSummary
            ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Games Played",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${gameResults.length}"),
                    SizedBox(height: 10),
                    Text("Win Rate",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_getWinRate())
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
                    Text(_getAverageDifficulty()),
                    SizedBox(height: 10),
                    Text("Average Guesses",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_getAverageGuesses()),
                  ],
                )
              ])
            : CircularProgressIndicator(),
      ),
    );
  }
}
