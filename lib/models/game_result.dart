import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'game_result.g.dart';

@HiveType(typeId: 0)
class GameResult extends Equatable {
  @HiveField(0)
  final String word;
  
  @HiveField(1)
  final String guesses;
  
  @HiveField(2)
  final bool didWin;
  
  @HiveField(3)
  final int numberOfGuesses;
  
  @HiveField(4)
  final DateTime time;
  
  @HiveField(5)
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
