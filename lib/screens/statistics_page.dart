import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hangman/bloc/blocs.dart';
import 'package:hangman/widgets/bold_section_header.dart';
import 'package:hangman/widgets/widgets.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  double _upperSectionHeight = 150;
  bool _displayUpperSection = true;
  Duration _animationDuration = Duration(milliseconds: 400);
  ScrollController _listViewController = ScrollController();
  _StatisticsPageState() {
    _listViewController.addListener(() => _toggleUpperSectionVisibility());
  }
  void _toggleUpperSectionVisibility() {
    setState(() {
      _upperSectionHeight = (_listViewController.offset > 100) ? 0 : 150;

      if (_upperSectionHeight == 0) {
        _displayUpperSection = false;
      }
    });
  }

  void _confirmDeleteStatistics(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permanently Delete All Data"),
            content: Text(
                "By clicking \"delete\", your data will be irreversibly deleted. Are you sure this is what you want?"),
            actions: [
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  BlocProvider.of<GameResultBloc>(context)
                      .add(GameResultDeleteAll());
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Exit"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameResultBloc, GameResultsState>(
        builder: (context, state) {
      if (!(state is GameResultsLoaded)) {
        return Scaffold(
          body: Container(
              alignment: Alignment.center, child: CircularProgressIndicator()),
        );
      }
      final gameResults = (state as GameResultsLoaded).gameResults
        ..sort((a, b) => b.time.compareTo(a.time));

      return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    size: 35,
                  ),
                  onPressed: () => _confirmDeleteStatistics(context))
            ],
            title: Container(
              child: Text("Statistics",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            )),
        body: Container(
          padding: EdgeInsets.all(50),
          child: Column(
            children: [
              BoldSectionHeader(
                  _upperSectionHeight > 0 ? "Summary" : "Summary..."),
              AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.ease,
                height: _upperSectionHeight,
                child: StatisticsSummaryCard(gameResults, _displayUpperSection),
              ),
              BoldSectionHeader(
                  _upperSectionHeight > 0 ? "Most Guessed" : "Most Guessed..."),
              AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.ease,
                height: _upperSectionHeight,
                child: StatisticsBarChart(gameResults, _displayUpperSection),
                onEnd: () {
                  setState(() {
                    _displayUpperSection = _upperSectionHeight != 0;
                  });
                },
              ),
              BoldSectionHeader("Game History"),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: gameResults.length,
                  itemBuilder: (context, int index) {
                    return StatisticsListItem(gameResults[index]);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  controller: _listViewController,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
