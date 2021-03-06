
import 'package:get_it/get_it.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/database/hive_game_result_data_service.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/dictionary/english_dictionary_service.dart';
import 'package:hangman/services/hangman/cheating_hangman_service.dart';

import 'hangman/hangman_service.dart';

final getIt = GetIt.instance;

void setupServiceLocater(){
  getIt.registerSingleton<DictionaryService>(EnglishDictionaryService());
  getIt.registerSingleton<GameResultDataService>(HiveGameResultDataService());
  getIt.registerSingleton<HangmanService>(CheatingHangmanService());
}