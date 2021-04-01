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
  int _wordLength;
  String _targetWord = "words";
  String _currentGuess;
  List<String> _lettersGuessed = <String>[];

  void _submitGuess() {
    guessController.clear();
    if (_lettersGuessed.contains(_currentGuess)) {
      //handle error here
    }
    setState(() {
      _lettersGuessed.add(_currentGuess);
      if (!_targetWord.contains(_currentGuess)) {
        _totalGuesses--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text("Quit"),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_targetWord.characters.map((char) =>_lettersGuessed.contains(char)? char : "_").join(' ')),
            Text("Guessed: ${_lettersGuessed.join(", ")}"),
            Text("Guesses Remaining: ${_totalGuesses}"),
            SizedBox(
              height: 50,
            ),
            TextField(
              maxLength: 1,
              onChanged: (String value) {
                setState(() {
                  _currentGuess = value;
                });
              },
              controller: guessController,
            ),
            ElevatedButton(onPressed: _submitGuess, child: Text("Guess"))
          ],
        ),
      ),
    );
  }
}
