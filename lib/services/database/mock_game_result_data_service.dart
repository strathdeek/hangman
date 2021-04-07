import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';

class MockGameResultDataService extends GameResultDataService{
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


}