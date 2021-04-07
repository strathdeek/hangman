import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/simple_bloc_observer.dart';
import 'package:hangman/constants/constants.dart';
import 'package:hangman/screens/game_page.dart';
import 'package:hangman/screens/game_setup_page.dart';
import 'package:hangman/screens/statistics_page.dart';
import 'package:hangman/services/service_locater.dart';

import 'bloc/blocs.dart';
import 'screens/main_page.dart';

void main() {
  setupServiceLocater();
  Bloc.observer = SimpleBlocObserver();
  // runApp(MyApp());
  runApp(BlocProvider(create: (context){
    return GameResultBloc()
    ..add(GameResultsLoadSuccessEvent());
  },
  child: MyApp(),));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.black))
        )

      ),
      routes: {
        Constants.GameSetupPageRouteName: (context) => GameSetupPage(),
        Constants.StatisticsPageRouteName: (context) => StatisticsPage(),
        Constants.GamePageRouteName: (context) => GamePage(5,5),
      },
      home: MainPage(),
    );
  }
}