import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/dictionary/english_dictionary_service.dart';
import 'package:hangman/services/service_locater.dart';

DictionaryService get dictionaryService => getIt<DictionaryService>();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    getIt.registerSingleton<DictionaryService>(EnglishDictionaryService());
    await dictionaryService.initializeDictionary();
  });
  group('dictionary service tests', () {
    test('get word of length 5', () async {
      var randomWord = await dictionaryService.getRandomWord(5);
      expect(randomWord.length, 5);
    });

    test('return a word for every possible word length', () async {
      var wordLengths = await dictionaryService.getPossibleWordLengths();
      wordLengths.forEach((length) async {
        var randomWord = await dictionaryService.getRandomWord(length);
        expect(randomWord.length, length);
      });
    });

    test('shortest word is shorter than longest word', () async {
      var shortest = await dictionaryService.getShortestWordLength();
      var longest = await dictionaryService.getLongestWordLength();
      expect(shortest <= longest, true);
    });

    test('get random word is returning with uniform distribution', () async {
      var wordLengths = await dictionaryService.getPossibleWordLengths();
      for (var wordLength in wordLengths) {
        var numOfWords =
            (await dictionaryService.getAllWords(wordLength)).length;
        var randomWords = <String>[];
        for (var i = 0; i < (numOfWords * 3); i++) {
          randomWords.add(await dictionaryService.getRandomWord(wordLength));
        }
        expect(randomWords.toSet().length > (.75 * numOfWords), true);
      }
    });
  });
}
