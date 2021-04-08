import 'package:hangman/constants/constants.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hive/hive.dart';

class HiveGameResultDataService extends GameResultDataService {
  Box<GameResult> gameResultBox;
  HiveGameResultDataService() {
    gameResultBox = Hive.box(Constants.HiveGameResultBoxKey);
  }
  @override
  Future<void> add(GameResult gameResult) async {
    await gameResultBox.put(gameResult.id, gameResult);
  }

  @override
  Future<List<GameResult>> get() async {
    return gameResultBox.values.toList();
  }

  @override
  Future<void> save(List<GameResult> newGameResults) async {
    newGameResults.forEach((game) {
      gameResultBox.put(game.id,game);
    });
  }
}
