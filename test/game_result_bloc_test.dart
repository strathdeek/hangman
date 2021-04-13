import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/bloc/game_result/game_result.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:mockito/mockito.dart';

class MockGameResultDataService extends Mock implements GameResultDataService {}

void main() {
  group('GameResultBloc', () {
    GameResultBloc gameResultBloc;
    GameResultDataService mockDataService;

    var result1 = GameResult("test1", "aeiou", false, 5,
        DateTime.fromMicrosecondsSinceEpoch(5), "1");
    var result2 = GameResult(
        "test2", "test2", true, 5, DateTime.fromMicrosecondsSinceEpoch(5), "2");
    var result3 = GameResult("test3", "qwerty", false, 5,
        DateTime.fromMicrosecondsSinceEpoch(5), "3");
    var result4 = GameResult(
        "test4", "test4", true, 5, DateTime.fromMicrosecondsSinceEpoch(5), "4");

    setUp(() {
      getIt.reset(dispose: true);
      mockDataService = MockGameResultDataService();
      getIt.registerSingleton<GameResultDataService>(mockDataService);
      gameResultBloc = GameResultBloc();
    });

    blocTest(
      'should emit GameResultsLoadFailure if repository throws',
      build: () {
        when(mockDataService.get()).thenThrow(Exception('oops'));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc.add(GameResultsLoad()),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoadFailed(Exception('oops').toString()),
      ],
    );

    blocTest(
      'should emit GameResultsLoadSuccess if repository loads',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc.add(GameResultsLoad()),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded(),
      ],
    );

    blocTest(
      'should add game result to repository in response to an add event',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async =>
          bloc..add(GameResultsLoad())..add(GameResultAdded(result1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([result1]),
      ],
    );

    blocTest(
      'should remove game result from repository in response to a remove event',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc
        ..add(GameResultsLoad())
        ..add(GameResultAdded(result1))
        ..add(GameResultDeleted(result1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([result1]),
        GameResultsLoaded([])
      ],
    );

    blocTest(
      'should remove specific game result from repository in response to a remove event',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc
        ..add(GameResultsLoad())
        ..add(GameResultAdded(result1))
        ..add(GameResultAdded(result2))
        ..add(GameResultAdded(result3))
        ..add(GameResultAdded(result4))
        ..add(GameResultDeleted(result1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([result1]),
        GameResultsLoaded([result1, result2]),
        GameResultsLoaded([result1, result2, result3]),
        GameResultsLoaded([result1, result2, result3, result4]),
        GameResultsLoaded([result2, result3, result4]),
      ],
    );

    blocTest(
      'should remove all game results from repository in response to a remove all event',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc
        ..add(GameResultsLoad())
        ..add(GameResultAdded(result1))
        ..add(GameResultAdded(result2))
        ..add(GameResultAdded(result3))
        ..add(GameResultAdded(result4))
        ..add(GameResultDeleteAll()),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([result1]),
        GameResultsLoaded([result1, result2]),
        GameResultsLoaded([result1, result2, result3]),
        GameResultsLoaded([result1, result2, result3, result4]),
        GameResultsLoaded([]),
      ],
    );

    blocTest(
      'should update game result to repository in response to an update event',
      build: () {
        when(mockDataService.get())
            .thenAnswer((_) => Future.value(<GameResult>[]));
        return gameResultBloc;
      },
      act: (GameResultBloc bloc) async => bloc
        ..add(GameResultsLoad())
        ..add(GameResultAdded(result1))
        ..add(GameResultUpdated(GameResult(
            "newword",
            result1.guesses,
            result1.didWin,
            result1.numberOfGuesses,
            result1.time,
            result1.id))),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([result1]),
        GameResultsLoaded([
          GameResult("newword", result1.guesses, result1.didWin,
              result1.numberOfGuesses, result1.time, result1.id)
        ]),
      ],
    );
  });
}
