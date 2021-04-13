import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/dictionary/english_dictionary_service.dart';
import 'package:hangman/services/service_locater.dart';

DictionaryService get dictionaryService => getIt<DictionaryService>();

void main() {
  setUpAll(() async {
    getIt.registerSingleton<DictionaryService>(EnglishDictionaryService());
    await dictionaryService.initializeDictionary();
  });
  group('dictionary service tests', () {
    test('get word of length 5', () async {
      var randomWord = await dictionaryService.getRandomWord(5);
      expect(randomWord.length, 5);
    });
  });
}
