import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _navigateToStartGame(){
    print("tapped start game");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Hangman"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _navigateToStartGame, child: Text("New Game")),
            ElevatedButton(onPressed: _navigateToStatistics, child: Text("Statistics"))
          ],
        )
      ),
    );
  }

  void _navigateToStatistics() {
    print("tapped statistics");
  }
}
