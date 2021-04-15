import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';

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
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image(image: AssetImage("assets/images/gallows.png")),
                height: 200,
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: _navigateToStartGame,
                        child: Text(
                          "Play",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: _navigateToStatistics,
                        child: Text(
                          "Statistics",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )))),
                  ),
                ],
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
