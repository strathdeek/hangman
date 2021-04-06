import 'dart:math';

import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:http/http.dart' as http;

class EnglishDictionaryService extends DictionaryService {
  EnglishDictionaryService() {
    initializeDictionary();
  }

  bool get isDictionaryInitialized => dictionary.length>0;
  List<String> dictionary = <String>[];
  Random rng = new Random();

  @override
  Future<String> getRandomWord(int numberOfLetters) async {
    if(!isDictionaryInitialized){
      await initializeDictionary();
    }
    
    var filteredDictionary = dictionary.where((element) => element.length==numberOfLetters);
    var randomIndex = rng.nextInt(filteredDictionary.length);
    return filteredDictionary.elementAt(randomIndex);
  }

  @override
  Future<void> initializeDictionary() async {
    if (isDictionaryInitialized) {
      return;
    }
    var response = await http.get(Uri.https("raw.githubusercontent.com",
        "mrdziuban/Hangman/master/dictionary.txt"));
    dictionary = response.body.split("\n");
  }

  @override
  Future<int> getLongestWordLength() async {
    if(!isDictionaryInitialized){
      await initializeDictionary();
    }
    dictionary.sort((a,b)=>a.length.compareTo(b.length)); 
    return dictionary.last.length;
  }

  @override
  Future<int> getShortestWordLength() async {
    if(!isDictionaryInitialized){
      await initializeDictionary();
    }
    dictionary.sort((a,b)=>a.length.compareTo(b.length)); 
    return dictionary.first.length;
  }
}
