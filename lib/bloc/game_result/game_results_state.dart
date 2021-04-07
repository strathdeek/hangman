import 'package:equatable/equatable.dart';
import 'package:hangman/models/game_result.dart';

abstract class GameResultsState extends Equatable{
  const GameResultsState();

  @override
  List<Object> get props => [];
}

class GameResultsLoadInProgress extends GameResultsState {}

class GameResultsLoadFailure extends GameResultsState {}

class GameResultsLoadSuccess extends GameResultsState {
  final List<GameResult> gameResults;

  const GameResultsLoadSuccess([this.gameResults = const []]);

  @override
  List<Object> get props => [gameResults];

  @override
  String toString() => 'GameResultsLoadSuccess { gameResults: $gameResults }';
}

