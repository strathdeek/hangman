abstract class DictionaryService{
  Future<void> initializeDictionary();
  Future<String> getRandomWord(int numberOfLetters);
  Future<int> getLongestWordLength();
  Future<int> getShortestWordLength();
}