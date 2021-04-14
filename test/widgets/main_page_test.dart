import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/bloc/game_result/game_result_bloc.dart';
import 'package:hangman/main.dart';
import 'package:hangman/screens/statistics_page.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:hangman/widgets/bold_section_header.dart';

import '../bloc/game_result_bloc_test.dart';

main() {
  testWidgets('homepage has a 2 buttons and an image',
      (WidgetTester tester) async {
    await tester.pumpWidget(BlocProvider(
      create: (context) {
        return GameResultBloc()..add(new GameResultsLoad());
      },
      child: MyApp(),
    ));
    final buttonFinder = find.byType(ElevatedButton);
    final imageFinder = find.byType(Image);

    expect(buttonFinder, findsNWidgets(2));
    expect(imageFinder, findsOneWidget);
  });
}
