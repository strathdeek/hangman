import 'dart:math';

import 'package:flutter/services.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:http/http.dart' as http;

class EnglishDictionaryService extends DictionaryService {
  EnglishDictionaryService() {
    initializeDictionary();
  }

  bool get isDictionaryInitialized => dictionary.length > 0;
  List<String> dictionary = <String>[];
  Random rng = new Random();

  @override
  Future<String> getRandomWord(int numberOfLetters) async {
    if (!isDictionaryInitialized) {
      await initializeDictionary();
    }

    var filteredDictionary =
        dictionary.where((element) => element.length == numberOfLetters);
    var randomIndex = rng.nextInt(filteredDictionary.length);
    return filteredDictionary.elementAt(randomIndex);
  }

  @override
  Future<void> initializeDictionary() async {
    if (isDictionaryInitialized) {
      return;
    }

    var dictionaryFile = await rootBundle
        .loadString('assets/dictionary/google-10000-english.txt');

    dictionary = dictionaryFile
        .split("\n")
        .where((String word) =>
            word.isNotEmpty && RegExp(r"[A-Za-z]").hasMatch(word))
        .map((word) => word.toUpperCase())
        .toList();
  }

  @override
  Future<int> getLongestWordLength() async {
    if (!isDictionaryInitialized) {
      await initializeDictionary();
    }
    dictionary.sort((a, b) => a.length.compareTo(b.length));
    return dictionary.last.length;
  }

  @override
  Future<int> getShortestWordLength() async {
    if (!isDictionaryInitialized) {
      await initializeDictionary();
    }
    dictionary.sort((a, b) => a.length.compareTo(b.length));
    print(dictionary.first);
    return dictionary.first.length;
  }

  @override
  Future<List<String>> getAllWords(int numberOfLetters) async {
    if (!isDictionaryInitialized) {
      await initializeDictionary();
    }
    return dictionary.where((word) => word.length == numberOfLetters).toList();
  }

  @override
  Future<List<int>> getPossibleWordLengths() async {
    if (!isDictionaryInitialized) {
      await initializeDictionary();
    }

    return dictionary.map((e) => e.length).toSet().toList();
  }
}
