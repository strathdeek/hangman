import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';
import 'package:hangman/screens/GamePage.dart';

class GameSetupPage extends StatefulWidget {
  @override
  _GameSetupPageState createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  double _guessCount = 5;
  double _letterCount = 5;

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
            Row(children: [
              Text(
                "Number of Guesses: ",
                textScaleFactor: 1.5,
              ),
              Text(_guessCount.round().toString(), textScaleFactor: 1.5)
            ]),
            Slider(
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
            Row(children: [
              Text(
                "Number of Letters: ",
                textScaleFactor: 1.5,
              ),
              Text(_letterCount.round().toString(), textScaleFactor: 1.5)
            ]),
            Slider(
              value: _letterCount,
              max: 10,
              min: 1,
              divisions: 10,
              label: _letterCount.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _letterCount = value;
                });
              },
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(_guessCount.round(),_letterCount.round())));
            }, child: Text("Play"))
          ],
        ),
      ),
    );
  }
}
