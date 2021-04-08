import 'package:hangman/models/game_result.dart';

abstract class GameResultDataService{
  Future<void> add(GameResult gameResult);
  Future<void> delete(GameResult gameResult);
  Future<void> deleteAll();
  Future<void> update(GameResult gameResult);
  Future<void> save(List<GameResult> newGameResults);
  Future<List<GameResult>> get();
}