import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';
import 'package:hangman/services/dictionary/dictionary_service.dart';
import 'package:hangman/services/service_locater.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _navigateToStartGame() {
    Navigator.pushNamed(context, Constants.GameSetupPageRouteName);
  }

  void _navigateToStatistics() {
    Navigator.pushNamed(context, Constants.StatisticsPageRouteName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HANGMAN"),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _navigateToStartGame, child: Text("New Game")),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: _navigateToStatistics, child: Text("Statistics")),
            ],
          )),
    );
  }
}
