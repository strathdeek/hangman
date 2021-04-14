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
    if (mode == GameMode.normal) {
      return currentWord;
    }
    Map<int, String> correctGuesses =
        getLetterIndexMap(alreadyGuessedLetters, currentWord);
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

    String incorrectRePattern = "[${incorrectGuesses.join("")}]";

    RegExp correctGuessesRegex = RegExp(correctRePattern);
    RegExp incorrectGuessesRegex = RegExp(incorrectRePattern);

    var wordsOfCorrectLength =
        await dictionaryService.getAllWords(currentWord.length);

    var possibleTargetWords = wordsOfCorrectLength.where((word) {
      return !incorrectGuessesRegex.hasMatch(word.toUpperCase()) &&
          correctGuessesRegex.hasMatch(word.toUpperCase());
    }).toList();
    if (mode == GameMode.hard) {
      return getHardestPossibleWord(possibleTargetWords, guess, currentWord);
    } else {
      return getEasiestPossibleWord(possibleTargetWords, guess, currentWord);
    }
  }

  Future<String> getHardestPossibleWord(List<String> possibleTargetWords,
      String guess, String currentWord) async {
    var bestTargetWords = possibleTargetWords
        .where((word) => !word.toUpperCase().contains(guess));

    if (bestTargetWords.isNotEmpty) {
      return bestTargetWords.elementAt(rng.nextInt(bestTargetWords.length));
    } else if (possibleTargetWords.isNotEmpty) {
      return possibleTargetWords
          .elementAt(rng.nextInt(possibleTargetWords.length));
    } else {
      return currentWord;
    }
  }

  // This method will attempt to select a word that contains the guessed letter.
  //
  // If there exist multiple possible words that contain the guessed letter,
  // the method will attempt to select a word that contains the guessed letter
  // at an index that is shared by the highest possible number of other words,
  // thereby giving the algorithm the highest chance of finding another match word
  // on the next iteration.
  //
  // If there are no possible words that contain the guess, this function will return
  // the current word.
  Future<String> getEasiestPossibleWord(List<String> possibleTargetWords,
      String guess, String currentWord) async {
    //each entry in this map represents an index in the target word, and list of possible words
    // that contain the 'guess' at that index
    var possibleTargetWordsMap = new Map<int, List<String>>();

    // sort all possible words into bins based on where the guess is located in the word
    possibleTargetWords.forEach((word) {
      var indexMap = getLetterIndexMap(guess, word);
      indexMap.forEach((index, letter) {
        if (!possibleTargetWordsMap.containsKey(index)) {
          possibleTargetWordsMap[index] = <String>[];
        }
        possibleTargetWordsMap[index].add(word);
      });
    });

    //sort the word bins to find the one with the most possible words
    var sortedLists = possibleTargetWordsMap.values.toList()
      ..sort((a, b) => a.length.compareTo(b.length));

    if (sortedLists.isEmpty) {
      return currentWord;
    }
    var longestList = sortedLists.last;
    return longestList.elementAt(rng.nextInt(longestList.length));
  }

// Return a map indicating the location of each letter of 'letters' within target 'word'
  Map<int, String> getLetterIndexMap(String letters, String word) {
    Map<int, String> letterIndices = Map<int, String>();

    letters.split('').forEach((letter) {
      if (word.contains(letter)) {
        //keep track of every index where the letter is found in the buffer
        var indexBuffer = <int>[];
        int letterIndex = word.indexOf(letter);
        while (letterIndex != -1) {
          indexBuffer.add(letterIndex);
          letterIndex = word.indexOf(letter, letterIndex + 1);
        }
        //after accounting for every match, save the results into the map and proceed to next letter
        indexBuffer.forEach((index) {
          letterIndices[index] = letter;
        });
      }
    });
    return letterIndices;
  }
}

// return a compatible word that is least likely to lead to a match given the current guesses
