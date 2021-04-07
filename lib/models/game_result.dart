import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GameResult extends Equatable {
  final String word;
  final String guesses;
  final bool didWin;
  final int numberOfGuesses;
  final DateTime time;
  final String id;

  GameResult(this.word, this.guesses, this.didWin, this.numberOfGuesses,
      this.time, String id)
      : this.id = id ?? UniqueKey();

  GameResult copyWith(GameResult toCopy) {
    return GameResult(
      word ?? this.word,
      guesses ?? this.guesses,
      didWin ?? this.didWin,
      numberOfGuesses ?? this.numberOfGuesses,
      time ?? this.time,
      id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, word, guesses, didWin, numberOfGuesses, time];

  @override
  String toString() => "GameResult: { word: $word, guesses: $guesses, didWin: $didWin, numberOfGuesses: $numberOfGuesses, time: $time, id: $id }";
  
}
