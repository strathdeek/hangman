import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/bloc/game_result/game_result_bloc.dart';
import 'package:hangman/constants/game_modes.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/hangman/hangman_service.dart';
import 'package:hangman/services/service_locater.dart';

class GamePage extends StatefulWidget {
  final int guesses;
  final int length;
  final GameMode gameMode;
  GamePage(this.guesses, this.length, this.gameMode) : super();
  @override
  _GamePageState createState() => _GamePageState(guesses, length, gameMode);
}

class _GamePageState extends State<GamePage> {
  _GamePageState(this._totalGuesses, int wordLength, this._gameMode) : super() {
    _loadTargetWord(wordLength);
  }

  final guessController = TextEditingController();
  final guessFocusNode = FocusNode();

  GameMode _gameMode;
  int _totalGuesses;
  int _currentGuesses = 0;
  String _errorText = "";
  String _targetWord = "words".toUpperCase();
  String _currentGuess = "";
  String get _displayWord => _targetWord.characters
      .map((char) => _lettersGuessed.contains(char) ? char : "_")
      .join();
  List<String> _lettersGuessed = <String>[];

  Future<void> _loadTargetWord(int numberOfLetters) async {
    var targetWord =
        await getIt<DictionaryService>().getRandomWord(numberOfLetters);
    print(targetWord);
    setState(() {
      _targetWord = targetWord.toUpperCase();
    });
  }

  void _trimTextInput(String input) {
    if (input?.isEmpty ?? true) {
      return;
    }
    var trimmedInput = input.characters.last.toUpperCase();
    guessController.clear();
    guessController.value = TextEditingValue(
        text: trimmedInput,
        selection: TextSelection.fromPosition(TextPosition(offset: 1)));
    setState(() {
      _currentGuess = trimmedInput;
    });
  }

  void _submitGuess() async {
    guessController.clear();

    if (_currentGuess.isEmpty) {
      return;
    }

    if (!RegExp("[A-Z]").hasMatch(_currentGuess)) {
      setState(() {
        _errorText = "'${_currentGuess.toUpperCase()}' is not a valid guess.";
      });
      guessFocusNode.requestFocus();
      return;
    }

    if (_lettersGuessed.contains(_currentGuess)) {
      setState(() {
        _errorText =
            "'${_currentGuess.toUpperCase()}' has already been guessed.";
      });
      guessFocusNode.requestFocus();
      return;
    }
    var newTargetWord = await getIt<HangmanService>().getNewWord(_currentGuess, _lettersGuessed.join(""), _targetWord, _gameMode);
    setState(() {
      _targetWord = newTargetWord.toUpperCase();
      _errorText = "";
      _lettersGuessed.add(_currentGuess);
      if (!_targetWord.contains(_currentGuess)) {
        _currentGuesses++;
      }
    });
    if (_currentGuesses == _totalGuesses || _targetWord == _displayWord) {
      _endGame();
    } else {
      guessFocusNode.requestFocus();
    }
  }

  Future<void> _endGame() async {
    var isWinner = _displayWord == _targetWord;

    BlocProvider.of<GameResultBloc>(context).add(GameResultAdded(new GameResult(
        _targetWord,
        _lettersGuessed.join(),
        isWinner,
        _totalGuesses,
        DateTime.now(),
        UniqueKey().toString())));

    var titleText = isWinner ? "Congratulations!" : "You Lost";
    var contentText = isWinner
        ? "You won! Would you like to play again?"
        : "The word was $_targetWord. Would you like to play again?";

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(contentText),
            actions: [
              TextButton(
                child: Text("Play Again"),
                onPressed: _resetGame,
              ),
              TextButton(
                child: Text("Exit"),
                onPressed: _navigateHome,
              ),
            ],
          );
        });
  }

  void _resetGame() {
    Navigator.of(context).pop();
    _loadTargetWord(_targetWord.length);
    setState(() {
      _currentGuesses = 0;
      _lettersGuessed = <String>[];
    });
  }

  void _navigateHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text("Quit"),
          onPressed: _navigateHome,
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Spacer(),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            _displayWord.characters.join(" "),
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Guesses Remaining: ${_totalGuesses - _currentGuesses}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            child: TextField(
                              buildCounter: (BuildContext context,
                                      {int currentLength,
                                      int maxLength,
                                      bool isFocused}) =>
                                  null,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 20),
                                border: OutlineInputBorder(),
                              ),
                              showCursor: false,
                              onChanged: _trimTextInput,
                              style: TextStyle(fontSize: 22),
                              controller: guessController,
                              onSubmitted: (String input) => _submitGuess(),
                              focusNode: guessFocusNode,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: _submitGuess,
                            child: Text("Guess"),
                          ),
                        ],
                      ),
                      Text(
                        _errorText,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Guessed: ${_lettersGuessed.join(", ")}",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer()
            ],
          )),
    );
  }
}
