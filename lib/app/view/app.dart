import 'package:api_client/api_client.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
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
    final crosswordResource = apiClient.crosswordResource;

    return MultiProvider(
      providers: [
        Provider.value(value: apiClient.leaderboardResource),
        Provider.value(value: crosswordResource),
        Provider.value(value: crosswordRepository),
        Provider.value(value: boardInfoRepository),
      ],
      child: BlocProvider(
        create: (_) => CrosswordBloc(
          crosswordRepository: crosswordRepository,
          boardInfoRepository: boardInfoRepository,
          crosswordResource: crosswordResource,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return IoLayout(
      child: BlocSelector<CrosswordBloc, CrosswordState, Mascots?>(
        selector: (state) {
          return state is CrosswordLoaded ? state.mascot : null;
        },
        builder: (context, mascot) {
          return MaterialApp(
            theme: mascot.theme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const GameIntroPage(),
          );
        },
      ),
    );
  }
}

@visibleForTesting
extension MascotTheme on Mascots? {
  static final flutterTheme = IoFlutterTheme().themeData;
  static final firebaseTheme = IoFirebaseTheme().themeData;
  static final chromeTheme = IoChromeTheme().themeData;
  static final androidTheme = IoAndroidTheme().themeData;
  static final defaultTheme = IoCrosswordTheme().themeData;

  ThemeData theme() {
    switch (this) {
      case Mascots.dash:
        return flutterTheme;
      case Mascots.sparky:
        return firebaseTheme;
      case Mascots.dino:
        return chromeTheme;
      case Mascots.android:
        return androidTheme;
      case null:
        return defaultTheme;
    }
  }
}
