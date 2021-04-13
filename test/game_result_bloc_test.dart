import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/bloc/game_result/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';
import 'package:mockito/mockito.dart';

class MockGameResultDataService extends Mock implements GameResultDataService {}

void main() {
  group('GameResultBloc', () {
    GameResultBloc gameResultBloc;
    GameResultDataService mockDataService;

    setUp(() {
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
        GameResultsLoadInProgress(),
        GameResultsLoadFailure(),
      ],
    );
  });
}
