import 'package:equatable/equatable.dart';
import 'package:hangman/models/game_result.dart';

abstract class GameResultEvent extends Equatable {
  const GameResultEvent();

  @override
  List<Object> get props => [];
}

class GameResultsLoad extends GameResultEvent {
  GameResultsLoad();
}

class GameResultAdded extends GameResultEvent {
  final GameResult gameResult;

  const GameResultAdded(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() => 'gameResults added { gameResult: $gameResult }';
}

class GameResultUpdated extends GameResultEvent {
  final GameResult gameResult;

  const GameResultUpdated(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() => 'GameResultUpdated { gameResult: $gameResult }';
}

class GameResultDeleted extends GameResultEvent {
  final GameResult gameResult;

  const GameResultDeleted(this.gameResult);

  @override
  List<Object> get props => [gameResult];

  @override
  String toString() => 'TodoDeleted { gameResult: $gameResult }';
}

class GameResultDeleteAll extends GameResultEvent {}
