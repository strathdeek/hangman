import 'package:flutter/material.dart';
import 'package:hangman/constants/game_modes.dart';
import 'package:hangman/screens/game_page.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:hangman/widgets/bold_section_header.dart';

class GameSetupPage extends StatefulWidget {
  @override
  _GameSetupPageState createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  double _guessCount = 12;
  int _letterCount = 6;
  int _minLetterCount = 1;
  int _maxLetterCount = 14;
  List<int> _allowedLengths;
  String _errorMessage = "";
  GameMode _gameMode = GameMode.normal;

  @override
  void initState() {
    super.initState();
    fetchDictionaryValues();
  }

  Future<void> fetchDictionaryValues() async {
    var min = await getIt<DictionaryService>().getShortestWordLength();
    var max = await getIt<DictionaryService>().getLongestWordLength();
    _allowedLengths = await getIt<DictionaryService>().getPossibleWordLengths();
    setState(() {
      _minLetterCount = min;
      _maxLetterCount = max <= 14 ? max : 14;
    });
  }

  void _setLetterCount(int letterCount) {
    setState(() {
      _letterCount = letterCount;
      _errorMessage = _allowedLengths.contains(letterCount)
          ? ""
          : "No available $letterCount letter words.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New Game",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            BoldSectionHeader("Guesses"),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      _guessCount.round().toString(),
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: Slider(
                        value: _guessCount,
                        max: 12,
                        min: 1,
                        divisions: 12,
                        label: _guessCount.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _guessCount = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            BoldSectionHeader("Word Length"),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      _letterCount.round().toString(),
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: Slider(
                        value: _letterCount.toDouble(),
                        max: _maxLetterCount.toDouble(),
                        min: _minLetterCount.toDouble(),
                        divisions: _maxLetterCount,
                        label: _letterCount.round().toString(),
                        onChanged: (value) => _setLetterCount(value.round()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(_errorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            Spacer(),
            BoldSectionHeader("Difficulty"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    ListTile(
                      leading: Radio(
                        value: GameMode.easy,
                        groupValue: _gameMode,
                        onChanged: (value) {
                          setState(() {
                            _gameMode = value;
                          });
                        },
                      ),
                      title: Text("Easy"),
                    ),
                    ListTile(
                      leading: Radio(
                        value: GameMode.normal,
                        groupValue: _gameMode,
                        onChanged: (value) {
                          setState(() {
                            _gameMode = value;
                          });
                        },
                      ),
                      title: Text("Normal"),
                    ),
                    ListTile(
                      leading: Radio(
                        value: GameMode.hard,
                        groupValue: _gameMode,
                        onChanged: (value) {
                          setState(() {
                            _gameMode = value;
                          });
                        },
                      ),
                      title: Text("Hard"),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (!_allowedLengths.contains(_letterCount)) {
                  return;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(_guessCount.round(),
                            _letterCount.round(), _gameMode)));
              },
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Play",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
