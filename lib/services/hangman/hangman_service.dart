import 'package:hangman/constants/game_modes.dart';

abstract class HangmanService{
  Future<String> getNewWord(String guess,String alreadyGuessedLetters, String currentWord, GameMode mode);
}