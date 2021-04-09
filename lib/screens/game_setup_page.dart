import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';
import 'package:hangman/screens/game_page.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:hangman/widgets/bold_section_header.dart';

class GameSetupPage extends StatefulWidget {
  @override
  _GameSetupPageState createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  double _guessCount = 5;
  double _letterCount = 5;
  int _minLetterCount = 1;
  int _maxLetterCount = 10;

  @override
  void initState() {
    super.initState();
    fetchDictionaryValues();
  }

  Future<void> fetchDictionaryValues() async {
    var min = await getIt<DictionaryService>().getShortestWordLength();
    var max = await getIt<DictionaryService>().getLongestWordLength();
    setState(() {
      _minLetterCount = min;
      _maxLetterCount = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BoldSectionHeader("Guesses"),
            Card(
                          child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Row(
                  children: [
                    Text(
                    _guessCount.round().toString(),
                    style: TextStyle(fontSize: 25),
                  ),
                    Expanded(
                                  child: Slider(
                        value: _guessCount,
                        max: 10,
                        min: 1,
                        divisions: 10,
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
                        value: _letterCount,
                        max: _maxLetterCount.toDouble(),
                        min: _minLetterCount.toDouble(),
                        divisions: _maxLetterCount,
                        label: _letterCount.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _letterCount = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamePage(
                              _guessCount.round(), _letterCount.round())));
                },
                child: Text("Play"))
          ],
        ),
      ),
    );
  }
}
