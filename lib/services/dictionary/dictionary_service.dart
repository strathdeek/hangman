abstract class DictionaryService{
  Future<void> initializeDictionary();
  Future<List<String>> getAllWords(int numberOfLetters);
  Future<String> getRandomWord(int numberOfLetters);
  Future<int> getLongestWordLength();
  Future<int> getShortestWordLength();
}