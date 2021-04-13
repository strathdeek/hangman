import 'package:equatable/equatable.dart';
import 'package:hangman/models/game_result.dart';

abstract class GameResultsState extends Equatable {
  const GameResultsState();

  @override
  List<Object> get props => [];
}

class GameResultsLoading extends GameResultsState {}

class GameResultsLoadFailed extends GameResultsState {
  final String error;

  const GameResultsLoadFailed([this.error]);

  @override
  List<Object> get props => [error];
}

class GameResultsAddFailed extends GameResultsState {
  final String error;

  const GameResultsAddFailed([this.error]);

  @override
  List<Object> get props => [error];
}

class GameResultsUpdateFailed extends GameResultsState {
  final String error;

  const GameResultsUpdateFailed([this.error]);

  @override
  List<Object> get props => [error];
}

class GameResultsDeleteFailed extends GameResultsState {
  final String error;

  const GameResultsDeleteFailed([this.error]);

  @override
  List<Object> get props => [error];
}

class GameResultsLoaded extends GameResultsState {
  final List<GameResult> gameResults;

  const GameResultsLoaded([this.gameResults = const []]);

  @override
  List<Object> get props => [gameResults];

  @override
  String toString() => 'GameResultsLoaded { gameResults: $gameResults }';
}
