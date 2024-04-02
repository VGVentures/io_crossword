import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    required this.apiClient,
    required this.crosswordRepository,
    required this.boardInfoRepository,
    super.key,
  });

  final ApiClient apiClient;
  final CrosswordRepository crosswordRepository;
  final BoardInfoRepository boardInfoRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: apiClient.leaderboardResource),
        Provider.value(value: apiClient.crosswordResource),
        Provider.value(value: crosswordRepository),
        Provider.value(value: boardInfoRepository),
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = IoCrosswordTheme().themeData;

    return MaterialApp(
      theme: themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ColoredBox(
        color: themeData.colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: themeData.copyWith(
                    cardTheme: themeData.io.cardTheme.highlight),
                child: Card(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: const Center(
                      child: Text('Highlighted Card'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Theme(
                data:
                    themeData.copyWith(cardTheme: themeData.io.cardTheme.plain),
                child: Card(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: const Center(
                      child: Text('Plain Card'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
