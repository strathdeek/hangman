import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _logoHidden = true;

  void _navigateToStartGame() async {
    setState(() {
      _logoHidden = false;
    });
    await Future.delayed(Duration(milliseconds: 1200));
    Navigator.pushNamed(context, Constants.GameSetupPageRouteName);
    setState(() {
      _logoHidden = true;
    });
  }

  void _navigateToStatistics() {
    Navigator.pushNamed(context, Constants.StatisticsPageRouteName);
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceOut,
                child: Image(image: AssetImage("assets/images/gallows.png")),
                top: _logoHidden ? -185 : 0,
                height: 250,
                width: 250,
                left: (screenWidth / 2) - 125,
              ),
              Positioned(
                left: (screenWidth / 2) - 75,
                top: 500,
                child: Column(
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
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
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
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
