import 'package:flutter/material.dart';
import 'package:hangman/constants/constants.dart';
import 'package:hangman/screens/GamePage.dart';
import 'package:hangman/screens/GameSetupPage.dart';
import 'package:hangman/screens/StatisticsPage.dart';

import 'screens/MainPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.black))
        )

      ),
      routes: {
        Constants.GameSetupPageRouteName: (context) => GameSetupPage(),
        Constants.StatisticsPageRouteName: (context) => StatisticsPage(),
        Constants.GamePageRouteName: (context) => GamePage(),
      },
      home: MainPage(),
    );
  }
}