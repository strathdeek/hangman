import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';

class GameResultBloc extends Bloc<GameResultEvent, GameResultsState> {
  final gameResultsDataService = getIt<GameResultDataService>();
  GameResultBloc() : super(GameResultsLoading());

  @override
  Stream<GameResultsState> mapEventToState(GameResultEvent event) async* {
    if (event is GameResultsLoad) {
      yield* _mapGameResultsLoadedToState();
    } else if (event is GameResultAdded) {
      yield* _mapGameResultAddedToState(event);
    } else if (event is GameResultDeleted) {
      yield* _mapGameResultDeletedToState(event);
    } else if (event is GameResultUpdated) {
      yield* _mapGameResultUpdateToState(event);
    } else if (event is GameResultDeleteAll) {
      yield* _mapGameResultDeleteAllToState();
    }
  }

  Stream<GameResultsState> _mapGameResultsLoadedToState() async* {
    try {
      yield GameResultsLoading();
      final gameResults = await gameResultsDataService.get() ?? <GameResult>[];
      yield GameResultsLoaded(gameResults);
    } catch (e) {
      yield GameResultsLoadFailed(e.toString());
    }
  }

  Stream<GameResultsState> _mapGameResultAddedToState(
      GameResultAdded event) async* {
    if (state is GameResultsLoaded) {
      try {
        await gameResultsDataService.add(event.gameResult);
        var updatedList =
            List<GameResult>.from((state as GameResultsLoaded).gameResults)
              ..add(event.gameResult);
        yield GameResultsLoaded(updatedList);
      } catch (e) {
        yield GameResultsAddFailed(e.toString());
      }
    }
  }

  Stream<GameResultsState> _mapGameResultDeletedToState(
      GameResultDeleted event) async* {
    if (state is GameResultsLoaded) {
      try {
        await gameResultsDataService.delete(event.gameResult);
        var updatedList =
            List<GameResult>.from((state as GameResultsLoaded).gameResults)
              ..remove(event.gameResult);
        yield GameResultsLoaded(updatedList);
      } catch (e) {
        yield GameResultsDeleteFailed(e.toString());
      }
    }
  }

  Stream<GameResultsState> _mapGameResultUpdateToState(
      GameResultUpdated event) async* {
    if (state is GameResultsLoaded) {
      try {
        await gameResultsDataService.update(event.gameResult);
        var updatedList =
            List<GameResult>.from((state as GameResultsLoaded).gameResults)
                .map((e) => e.id == event.gameResult.id ? event.gameResult : e)
                .toList();
        yield GameResultsLoaded(updatedList);
      } catch (e) {
        yield GameResultsUpdateFailed(e.toString());
      }
    }
  }

  Stream<GameResultsState> _mapGameResultDeleteAllToState() async* {
    if (state is GameResultsLoaded) {
      try {
        await gameResultsDataService.deleteAll();
        var updatedList = <GameResult>[];
        yield GameResultsLoaded(updatedList);
      } catch (e) {
        yield GameResultsDeleteFailed(e.toString());
      }
    }
  }
}
