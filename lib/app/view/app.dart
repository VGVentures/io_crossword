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
    return MaterialApp(
      theme: IoCrosswordTheme.themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CrosswordPage(),
    );
  }
}
