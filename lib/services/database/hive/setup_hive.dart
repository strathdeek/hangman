import 'package:hangman/constants/constants.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeHiveDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameResultAdapter());
    await Hive.openBox<GameResult>(Constants.HiveGameResultBoxKey);
}

