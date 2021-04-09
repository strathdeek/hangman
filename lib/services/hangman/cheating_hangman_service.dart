import 'dart:math';

import 'package:hangman/constants/game_modes.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/hangman/hangman_service.dart';

import '../service_locater.dart';

class CheatingHangmanService extends HangmanService {
  DictionaryService get dictionaryService => getIt<DictionaryService>();
  Random rng = new Random();

  @override
  Future<String> getNewWord(String guess, String alreadyGuessedLetters,
      String currentWord, GameMode mode) async {
    switch (mode) {
      case GameMode.easy:
        return currentWord;
      case GameMode.normal:
        return currentWord;
      case GameMode.hard:
        return getHardestPossibleWord(guess, alreadyGuessedLetters, currentWord);
      default:
        return currentWord;
    }
  }

  // return a compatible word that is least likely to lead to a match given the current guesses
  Future<String> getHardestPossibleWord(
      String guess, String alreadyGuessedLetters, String currentWord) async {
    Map<int, String> correctGuesses =
        getCorrectGuessesMap(alreadyGuessedLetters, currentWord);

    List<String> incorrectGuesses = alreadyGuessedLetters.split("");
    String correctRePattern = r"";
    for (var i = 0; i < currentWord.length; i++) {
      if (correctGuesses.containsKey(i)) {
        correctRePattern += correctGuesses[i];
        incorrectGuesses.remove(correctGuesses[i]);
      } else {
        correctRePattern += ".";
      }
    }

    String newGuessRePattern = "[$guess]";
    String incorrectRePattern = "[${incorrectGuesses.join("")}]";

    RegExp correctGuessesRegex = RegExp(correctRePattern);
    RegExp incorrectGuessesRegex = RegExp(incorrectRePattern);
    RegExp newGuessRegex = RegExp(newGuessRePattern);

    var wordsOfCorrectLength =
        await dictionaryService.getAllWords(currentWord.length);

    var possibleTargetWords = wordsOfCorrectLength.where((word) {
      return !incorrectGuessesRegex.hasMatch(word.toUpperCase()) &&
          correctGuessesRegex.hasMatch(word.toUpperCase());
    });

    var bestTargetWords =
        possibleTargetWords.where((word) => !newGuessRegex.hasMatch(word.toUpperCase()));

    if (bestTargetWords.isNotEmpty) {
      return bestTargetWords.elementAt(rng.nextInt(bestTargetWords.length));
    } else {
      return possibleTargetWords
          .elementAt(rng.nextInt(possibleTargetWords.length));
    }
  }

  Future<String> getEasiestPossibleWord(
      String guesses, String currentWord) async {}
}

Map<int, String> getCorrectGuessesMap(String guesses, String currentWord) {
  Map<int, String> correctGuesses = Map<int, String>();
  var lettersGuessed = guesses.split('');

  lettersGuessed.forEach((letter) {
    if (currentWord.contains(letter)) {
      var correctGuessIndices = <int>[];
      int correctGuessIndex = currentWord.indexOf(letter);
      while (correctGuessIndex != -1) {
        correctGuessIndices.add(correctGuessIndex);
        correctGuessIndex = currentWord.indexOf(letter, correctGuessIndex + 1);
      }
      correctGuessIndices.forEach((index) {
        correctGuesses[index] = letter;
      });
    }
  });
  return correctGuesses;
}
