import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/bloc/game_result/game_result.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:mockito/mockito.dart';

import 'dummy_game_results.dart';

class MockGameResultDataService extends Mock implements GameResultDataService {}

void main() {
  group('GameResultBloc', () {
    GameResultBloc gameResultBloc;
    GameResultDataService mockDataService;
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
          bloc..add(GameResultsLoad())..add(GameResultAdded(dummyGameResult1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([dummyGameResult1]),
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
        ..add(GameResultAdded(dummyGameResult1))
        ..add(GameResultDeleted(dummyGameResult1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([dummyGameResult1]),
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
        ..add(GameResultAdded(dummyGameResult1))
        ..add(GameResultAdded(dummyGameResult2))
        ..add(GameResultAdded(dummyGameResult3))
        ..add(GameResultAdded(dummyGameResult4))
        ..add(GameResultDeleted(dummyGameResult1)),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([dummyGameResult1]),
        GameResultsLoaded([dummyGameResult1, dummyGameResult2]),
        GameResultsLoaded(
            [dummyGameResult1, dummyGameResult2, dummyGameResult3]),
        GameResultsLoaded([
          dummyGameResult1,
          dummyGameResult2,
          dummyGameResult3,
          dummyGameResult4
        ]),
        GameResultsLoaded(
            [dummyGameResult2, dummyGameResult3, dummyGameResult4]),
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
        ..add(GameResultAdded(dummyGameResult1))
        ..add(GameResultAdded(dummyGameResult2))
        ..add(GameResultAdded(dummyGameResult3))
        ..add(GameResultAdded(dummyGameResult4))
        ..add(GameResultDeleteAll()),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([dummyGameResult1]),
        GameResultsLoaded([dummyGameResult1, dummyGameResult2]),
        GameResultsLoaded(
            [dummyGameResult1, dummyGameResult2, dummyGameResult3]),
        GameResultsLoaded([
          dummyGameResult1,
          dummyGameResult2,
          dummyGameResult3,
          dummyGameResult4
        ]),
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
        ..add(GameResultAdded(dummyGameResult1))
        ..add(GameResultUpdated(GameResult(
            "newword",
            dummyGameResult1.guesses,
            dummyGameResult1.didWin,
            dummyGameResult1.numberOfGuesses,
            dummyGameResult1.time,
            dummyGameResult1.id))),
      expect: () => [
        GameResultsLoading(),
        GameResultsLoaded([]),
        GameResultsLoaded([dummyGameResult1]),
        GameResultsLoaded([
          GameResult(
              "newword",
              dummyGameResult1.guesses,
              dummyGameResult1.didWin,
              dummyGameResult1.numberOfGuesses,
              dummyGameResult1.time,
              dummyGameResult1.id)
        ]),
      ],
    );
  });
}
