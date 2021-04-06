import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final int guesses;
  final int length;
  GamePage(this.guesses, this.length) : super();
  @override
  _GamePageState createState() => _GamePageState(guesses, length);
}

class _GamePageState extends State<GamePage> {
  _GamePageState(this._totalGuesses, this._wordLength) : super();

  final guessController = TextEditingController();

  int _totalGuesses;
  int _currentGuesses = 0;
  int _wordLength;
  String _errorText = "";
  String _targetWord = "words".toUpperCase();
  String _currentGuess;
  String get _displayWord => _targetWord.characters
      .map((char) => _lettersGuessed.contains(char) ? char : "_")
      .join();
  List<String> _lettersGuessed = <String>[];

  void _trimTextInput(String input){
    var trimmedInput = input.characters.last.toUpperCase();
    guessController.clear();
    guessController.value = TextEditingValue(text: trimmedInput, selection: TextSelection.fromPosition(TextPosition(offset: 1)));
    setState(() {
      _currentGuess = trimmedInput;
    });

  }

  void _submitGuess() {
    guessController.clear();
    print(_currentGuess);
    print(_lettersGuessed);
    print(_lettersGuessed.contains(_currentGuess));
    if (_lettersGuessed.contains(_currentGuess)) {
      setState(() {
        _errorText = "'${_currentGuess.toUpperCase()}' has already been guessed.";
      });
      return;
    }
    setState(() {
      _errorText = "";
      _lettersGuessed.add(_currentGuess);
      if (!_targetWord.contains(_currentGuess)) {
        _currentGuesses++;
      }
    });
    if (_currentGuesses == _totalGuesses || _targetWord == _displayWord) {
      _endGame();
    }
  }

  Future<void> _endGame() async {
    var isWinner = _displayWord == _targetWord;
    var titleText = isWinner ? "Congratulations!" : "Maybe next time";
    var contentText = isWinner
        ? "You won! Would you like to play again?"
        : "You lost. Would you like to play again?";

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
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_displayWord.characters.join(" ")),
            Text("Guessed: ${_lettersGuessed.join(", ")}"),
            Text("Guesses Remaining: ${_totalGuesses - _currentGuesses}"),
            SizedBox(
              height: 50,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 50,
                  alignment: Alignment.center,
                  child: TextField(
                    buildCounter: (BuildContext context,
                            {int currentLength,
                            int maxLength,
                            bool isFocused}) =>
                        null,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 35),
                      border: OutlineInputBorder(),
                    ),
                    showCursor: false,
                    onChanged: _trimTextInput,
                    style: TextStyle(fontSize: 22),
                    controller: guessController,
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
            Text(_errorText, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
