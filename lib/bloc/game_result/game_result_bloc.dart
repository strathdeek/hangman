import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/models/game_result.dart';
import 'package:hangman/services/database/game_result_data_service.dart';
import 'package:hangman/services/service_locater.dart';

class GameResultBloc extends Bloc<GameResultEvent, GameResultsState> {
  final gameResultsDataService = getIt<GameResultDataService>();
  GameResultBloc() : super(GameResultsLoadInProgress());

  @override
  Stream<GameResultsState> mapEventToState(GameResultEvent event) async* {
    if (event is GameResultsLoadSuccessEvent) {
      yield* _mapGameResultsLoadedToState();
    } else if (event is GameResultAdded) {
      yield* _mapGameResultAddedToState(event);
    } else if (event is GameResultDeleted) {
      yield* _mapGameResultDeletedToState(event);
    } else if (event is GameResultUpdated) {
      yield* _mapGameResultUpdateToState(event);
    }
  }

  Stream<GameResultsState> _mapGameResultsLoadedToState() async* {
    try {
      final gameResults = await gameResultsDataService.get();
      print("just fetched $gameResults from db");
      yield GameResultsLoadSuccess(gameResults);
    } catch (e) {
      yield GameResultsLoadFailure();
    }
  }

  Stream<GameResultsState> _mapGameResultAddedToState(GameResultAdded event) async* {
    if(state is GameResultsLoadSuccess){
      final List<GameResult> updatedResults = List.from((state as GameResultsLoadSuccess).gameResults)
        ..add(event.gameResult);
      yield GameResultsLoadSuccess(updatedResults);
      _saveGameResults(updatedResults);
    }
  }

  Stream<GameResultsState> _mapGameResultDeletedToState(GameResultDeleted event) async* {
    if (state is GameResultsLoadSuccess) {
      final List<GameResult> updatedResults = List.from((state as GameResultsLoadSuccess).gameResults)
        ..remove(event.gameResult);
      yield GameResultsLoadSuccess(updatedResults);
      _saveGameResults(updatedResults);
    }
  }

  Stream<GameResultsState> _mapGameResultUpdateToState(GameResultUpdated event) async* {
    if (state is GameResultsLoadSuccess) {
      final List<GameResult> updatedResults = (state as GameResultsLoadSuccess).gameResults
        .map((result) => result.id == event.gameResult.id ? event.gameResult : result)
        .toList();
      yield GameResultsLoadSuccess(updatedResults);
      _saveGameResults(updatedResults);
    }
  }

  Future<void> _saveGameResults(List<GameResult> gameResults) async {
    return getIt<GameResultDataService>().save(gameResults);
  }
}
