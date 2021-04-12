import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';

class MockGameResultDataService extends GameResultDataService {
  final List<GameResult> gameResults = <GameResult>[];
  @override
  Future<void> add(GameResult gameResult) async {
    return gameResults.add(gameResult);
  }

  @override
  Future<List<GameResult>> get() async {
    return gameResults;
  }

  @override
  Future<void> save(List<GameResult> newGameResults) async {
    gameResults.clear();
    gameResults.addAll(newGameResults);
  }

  @override
  Future<void> delete(GameResult gameResult) async {
    gameResults.remove(gameResult);
  }

  @override
  Future<void> deleteAll() async {
    gameResults.clear();
  }

  @override
  Future<void> update(GameResult gameResult) async {
    gameResults.map((e) => e.id == gameResult.id ? gameResult : e);
  }
}
