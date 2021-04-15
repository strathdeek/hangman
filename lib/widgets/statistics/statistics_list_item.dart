import 'package:flutter/material.dart';
import 'package:hangman/models/game_result.dart';
import 'package:intl/intl.dart';

import '../widgets.dart';

class StatisticsListItem extends StatelessWidget {
  final GameResult gameResult;

  StatisticsListItem(this.gameResult);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: gameResult.didWin ? Colors.green.shade50 : Colors.red.shade50,
        child: Container(
            padding: EdgeInsets.all(15),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              HangmanDrawing(
                size: Size(40, 80),
                guesses: gameResult.guesses.characters
                    .where((c) => !gameResult.word.contains(c))
                    .length,
                hasLost: !gameResult.didWin,
                isThumbnail: true,
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Word", style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(height: 55, child: Text("${gameResult.word}")),
                  Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${DateFormat.MMMd().format(gameResult.time)}")
                ],
              ),
              Spacer(),
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
                    height: 55,
                    width: 120,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: gameResult.guesses.characters
                          .map((c) => Text(c,
                              style: TextStyle(
                                  color: gameResult.word.contains(c)
                                      ? Colors.green
                                      : Colors.red)))
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
