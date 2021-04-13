import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';

class GameResultBloc extends Bloc<GameResultEvent, GameResultsState> {
  final gameResultsDataService = getIt<GameResultDataService>();
  GameResultBloc() : super(GameResultsLoadInProgress());

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
      yield GameResultsLoadInProgress();
      final gameResults = await gameResultsDataService.get();
      yield GameResultsLoadSuccess(gameResults);
    } catch (e) {
      yield GameResultsLoadFailure();
    }
  }

  Stream<GameResultsState> _mapGameResultAddedToState(
      GameResultAdded event) async* {
    if (state is GameResultsLoadSuccess) {
      await gameResultsDataService.add(event.gameResult);
      add(GameResultsLoad());
    }
  }

  Stream<GameResultsState> _mapGameResultDeletedToState(
      GameResultDeleted event) async* {
    if (state is GameResultsLoadSuccess) {
      await gameResultsDataService.delete(event.gameResult);
      add(GameResultsLoad());
    }
  }

  Stream<GameResultsState> _mapGameResultUpdateToState(
      GameResultUpdated event) async* {
    if (state is GameResultsLoadSuccess) {
      await gameResultsDataService.update(event.gameResult);
      add(GameResultsLoad());
    }
  }

  Stream<GameResultsState> _mapGameResultDeleteAllToState() async* {
    if (state is GameResultsLoadSuccess) {
      await gameResultsDataService.deleteAll();
      add(GameResultsLoad());
    }
  }
}
