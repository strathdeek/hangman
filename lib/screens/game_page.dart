import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/bloc/game_result/game_result_bloc.dart';
import 'package:hangman/constants/game_modes.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/hangman/hangman_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:hangman/widgets/hangman_drawing.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
        onChange: (keyboardOpen) => _toggleEntryUI(keyboardOpen));
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
  Duration _animationDuration = Duration(milliseconds: 500);
  Curve _animationCurve = Curves.fastOutSlowIn;
  bool _keyboardActive = false;

  Future<void> _loadTargetWord(int numberOfLetters) async {
    var targetWord =
        await getIt<DictionaryService>().getRandomWord(numberOfLetters);
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
      return;
    }
    var newTargetWord = await getIt<HangmanService>().getNewWord(
        _currentGuess, _lettersGuessed.join(""), _targetWord, _gameMode);
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

  List<Widget> _getTextList(String word) {
    var list = <Text>[];
    word.characters.join(' ').characters.forEach((char) {
      list.add(Text(
        char,
        style: TextStyle(fontSize: 25),
      ));
    });
    return list;
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

  void _toggleEntryUI(bool keyboardOpen) {
    setState(() {
      _keyboardActive = keyboardOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double rawHeight = MediaQuery.of(context).size.height;
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);
    var safeAreaHeight = rawHeight - viewInsets.bottom;
    var hangManDrawingHeight = safeAreaHeight - 375;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text("Quit"),
          onPressed: _navigateHome,
        ),
        title: Text("Hangman",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
          ),
          Positioned(
            top: 5,
            width: hangManDrawingHeight / 2,
            left: (screenWidth / 2) - (hangManDrawingHeight / 4),
            height: hangManDrawingHeight,
            child: HangmanDrawing(
              guesses: _currentGuesses,
              hasLost: _currentGuesses == _totalGuesses,
              size: Size(
                hangManDrawingHeight / 2,
                hangManDrawingHeight,
              ),
            ),
            // duration: _animationDuration,
            // curve: _animationCurve,
          ),
          AnimatedPositioned(
            duration: _animationDuration,
            curve: _animationCurve,
            height: _keyboardActive ? 85 : 85,
            width: screenWidth - 100,
            bottom: _keyboardActive ? 145 : 155,
            right: 50,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Wrap(
                      children: _getTextList(_displayWord),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Guesses Remaining: ${_totalGuesses - _currentGuesses}"),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: _animationDuration,
            curve: _animationCurve,
            height: _keyboardActive ? 100 : 150,
            width: screenWidth - 100,
            bottom: _keyboardActive ? 45 : 5,
            right: 50,
            child: Card(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: _animationDuration,
                    curve: _animationCurve,
                    height: _keyboardActive ? 80 : 100,
                    width: 75,
                    top: _keyboardActive ? 5 : 25,
                    left: 10,
                    child: TextField(
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 40),
                        border: OutlineInputBorder(),
                      ),
                      showCursor: false,
                      onChanged: _trimTextInput,
                      style: TextStyle(fontSize: 50),
                      controller: guessController,
                      onSubmitted: (String input) => _submitGuess(),
                      focusNode: guessFocusNode,
                    ),
                  ),
                  Positioned(
                    top: _keyboardActive ? 5 : 25,
                    left: 95,
                    width: screenWidth - 205,
                    child: Column(
                      children: [
                        Text(
                          "Guesses:",
                          style: TextStyle(fontSize: 25),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: _lettersGuessed
                              .map((c) => Text(c,
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: _targetWord.contains(c)
                                          ? Colors.green
                                          : Colors.red)))
                              .toList(),
                        ),
                        Text(
                          _errorText,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: _animationDuration,
            curve: _animationCurve,
            height: _keyboardActive ? 45 : 35,
            width: _keyboardActive ? screenWidth - 2 : 150,
            bottom: _keyboardActive ? -5 : 15,
            right: _keyboardActive ? 1 : 60,
            child: ElevatedButton(
              onPressed: _submitGuess,
              child: Text(
                "Guess",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _keyboardActive ? 25 : 15),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
