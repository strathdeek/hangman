import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/screens/screens.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:hangman/widgets/widgets.dart';

import '../bloc/dummy_game_results.dart';
import '../bloc/game_result_bloc_test.dart';
import '../test_utils.dart';

main() {
  setUpAll(() {
    getIt.registerSingleton<GameResultDataService>(MockGameResultDataService());
  });

  group('empty statistics page', () {
    testWidgets('empty statistics page has 3 headers',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()..add(GameResultsLoad());
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final headerFinder = find.byType(BoldSectionHeader);

      expect(headerFinder, findsNWidgets(3));
    });

    testWidgets('empty statistics page has two cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()..add(GameResultsLoad());
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final cardFinder = find.byType(Card);

      expect(cardFinder, findsNWidgets(2));
    });

    testWidgets('empty statistics page has no stats',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()..add(GameResultsLoad());
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final miscStatsFinder = find.text("-");
      final gamesPlayedFinder = find.text("0");

      expect(gamesPlayedFinder, findsOneWidget);
      expect(miscStatsFinder, findsNWidgets(3));
    });

    testWidgets('empty statistics page has no chart',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()..add(GameResultsLoad());
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final barChartFinder = find.byType(BarChart);

      expect(barChartFinder, findsNothing);
    });

    testWidgets('empty statistics page has empty listview',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()..add(GameResultsLoad());
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final listViewItemFinder = find.byType(StatisticsListItem);

      expect(listViewItemFinder, findsNothing);
    });
  });

  group('statistics page with data', () {
    testWidgets('populated statistics page has 3 headers',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()
            ..add(GameResultsLoad())
            ..add(GameResultAdded(dummyGameResult1))
            ..add(GameResultAdded(dummyGameResult2))
            ..add(GameResultAdded(dummyGameResult3))
            ..add(GameResultAdded(dummyGameResult4));
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final headerFinder = find.byType(BoldSectionHeader);

      expect(headerFinder, findsNWidgets(3));
    });

    testWidgets('populated statistics page has bar chart',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()
            ..add(GameResultsLoad())
            ..add(GameResultAdded(dummyGameResult1))
            ..add(GameResultAdded(dummyGameResult2))
            ..add(GameResultAdded(dummyGameResult3))
            ..add(GameResultAdded(dummyGameResult4));
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final finder = find.byType(BarChart);

      expect(finder, findsOneWidget);
    });

    testWidgets('populated statistics page has correct number of list items',
        (WidgetTester tester) async {
      await tester.pumpWidget(BlocProvider(
        create: (context) {
          return GameResultBloc()
            ..add(GameResultsLoad())
            ..add(GameResultAdded(dummyGameResult1));
        },
        child: createWidgetForTesting(child: StatisticsPage()),
      ));

      await tester.pumpAndSettle();
      final finder = find.byType(StatisticsListItem);

      expect(finder, findsOneWidget);
    });
  });
}
