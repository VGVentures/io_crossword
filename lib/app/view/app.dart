import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/challenge/challenge.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:provider/provider.dart';

const _kPhoneWidth = 1000;

class App extends StatelessWidget {
  const App({
    required this.apiClient,
    required this.crosswordRepository,
    required this.boardInfoRepository,
    required this.leaderboardRepository,
    required this.user,
    super.key,
  });

  final ApiClient apiClient;
  final User user;
  final CrosswordRepository crosswordRepository;
  final BoardInfoRepository boardInfoRepository;
  final LeaderboardRepository leaderboardRepository;

  @override
  Widget build(BuildContext context) {
    final crosswordResource = apiClient.crosswordResource;


    return MultiProvider(
      providers: [
        Provider.value(value: apiClient.leaderboardResource),
        Provider.value(value: user),
        Provider.value(value: crosswordResource),
        Provider.value(value: crosswordRepository),
        Provider.value(value: boardInfoRepository),
        Provider.value(value: leaderboardRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CrosswordBloc(
              crosswordRepository: crosswordRepository,
              boardInfoRepository: boardInfoRepository,
            ),
          ),
          BlocProvider(
            // coverage:ignore-start
            create: (_) => PlayerBloc(
              leaderboardRepository: leaderboardRepository,
            )..add(PlayerLoaded(userId: user.id)),
            // coverage:ignore-end
          ),
          BlocProvider(
            create: (context) => ChallengeBloc(
              boardInfoRepository: context.read(),
            )..add(const ChallengeDataRequested()),
          ),
        ],
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
          return state.mascot;
        },
        builder: (context, mascot) {
          return RotatedBox(
            quarterTurns:
                (MediaQuery.of(context).orientation == Orientation.landscape &&
                        IoLayout.of(context) == IoLayoutData.small)
                    ? 1
                    : 0,
            child: MaterialApp(
              theme: mascot.theme(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const GameIntroPage(),
            ),
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
