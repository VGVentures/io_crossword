import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/app_lifecycle/app_lifecycle.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword/rotate_phone/rotate_phone.dart';
import 'package:io_crossword/settings/settings.dart';
import 'package:io_crossword/welcome/welcome.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:provider/provider.dart';

typedef CreateAudioController = AudioController Function();

@visibleForTesting
AudioController updateAudioController(
  BuildContext context,
  SettingsController settings,
  ValueNotifier<AppLifecycleState> lifecycleNotifier,
  AudioController? audio, {
  CreateAudioController createAudioController = AudioController.new,
}) {
  return audio ?? createAudioController()
    ..initialize()
    ..attachSettings(settings)
    ..attachLifecycleNotifier(lifecycleNotifier);
}

class App extends StatelessWidget {
  const App({
    required this.apiClient,
    required this.crosswordRepository,
    required this.boardInfoRepository,
    required this.leaderboardRepository,
    required this.user,
    this.audioController,
    super.key,
  });

  final ApiClient apiClient;
  final User user;
  final CrosswordRepository crosswordRepository;
  final BoardInfoRepository boardInfoRepository;
  final LeaderboardRepository leaderboardRepository;
  final AudioController? audioController;

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider.value(value: apiClient.crosswordResource),
          Provider.value(value: apiClient.leaderboardResource),
          Provider.value(value: apiClient.hintResource),
          Provider.value(value: user),
          Provider.value(value: crosswordRepository),
          Provider.value(value: boardInfoRepository),
          Provider.value(value: leaderboardRepository),
          Provider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
              AudioController>(
            // Ensures that the AudioController is created on startup,
            // and not "only when it's needed", as is default behavior.
            // This way, music starts immediately.
            lazy: false,
            create: (context) =>
                audioController ?? (AudioController()..initialize()),
            update: updateAudioController,
            dispose: (context, audio) => audio.dispose(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => PlayerBloc(
                leaderboardResource: apiClient.leaderboardResource,
                leaderboardRepository: leaderboardRepository,
              )..add(PlayerLoaded(userId: user.id)),
            ),
          ],
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return IoLayout(
      child: BlocSelector<PlayerBloc, PlayerState, Mascots?>(
        selector: (state) {
          return state.mascot;
        },
        builder: (context, mascot) {
          return MaterialApp(
            theme: mascot.theme(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const WelcomePage(),
            builder: (context, child) {
              return Stack(
                children: [
                  if (child != null) child,
                  if (context.isMobileLandscape) const RotatePhonePage(),
                ],
              );
            },
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

extension MobileLandscapeHelper on BuildContext {
  /// True if running in landscape mode on a small device
  bool get isMobileLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape &&
      IoLayout.of(this) == IoLayoutData.small &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
}
