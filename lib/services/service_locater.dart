
import 'package:get_it/get_it.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/dictionary/english_dictionary_service.dart';

final getIt = GetIt.instance;

void setupServiceLocater(){
  getIt.registerSingleton<DictionaryService>(EnglishDictionaryService());
}