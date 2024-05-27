import 'package:api_client/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/how_to_play/view/how_to_play_page.dart';
import 'package:io_crossword/initials/initials.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/player/player.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsPage extends StatelessWidget {
  const InitialsPage({super.key});

  @visibleForTesting
  static const routeName = '/initials';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const InitialsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InitialsBloc(
        leaderboardResource: context.read<LeaderboardResource>(),
      )..add(const InitialsBlocklistRequested()),
      child: const InitialsView(),
    );
  }
}

@visibleForTesting
class InitialsView extends StatefulWidget {
  const InitialsView({super.key});

  @override
  State<InitialsView> createState() => _InitialsViewState();
}

class _InitialsViewState extends State<InitialsView> {
  final _wordInputController = IoWordInputController();

  void _onSubmit(BuildContext context) {
    context.read<InitialsBloc>()
      ..add(const InitialsBlocklistRequested())
      ..add(InitialsSubmitted(_wordInputController.word));
  }

  void _onSuccess(BuildContext context, InitialsState state) {
    context.read<PlayerBloc>().add(InitialsSelected(state.initials.value));
    Navigator.of(context).push(HowToPlayPage.route());
  }

  @override
  void dispose() {
    _wordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).io.textStyles;

    return BlocListener<InitialsBloc, InitialsState>(
      listenWhen: (previous, current) => current.initials.isValid,
      listener: _onSuccess,
      child: Scaffold(
        appBar: IoAppBar(
          crossword: l10n.crossword,
          actions: (context) => const MuteButton(),
        ),
        body: SelectionArea(
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 294),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      l10n.enterInitials,
                      textAlign: TextAlign.center,
                      style: textTheme.heading1,
                    ),
                    const SizedBox(height: 32),
                    IoWordInput.alphabetic(
                      length: 3,
                      controller: _wordInputController,
                      onSubmit: (_) => _onSubmit(context),
                    ),
                    SizedBox(
                      height: 64,
                      child: BlocSelector<InitialsBloc, InitialsState,
                          InitialsInputError?>(
                        selector: (state) => state.initials.displayError,
                        builder: (context, error) {
                          if (error == null) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: InitialsErrorText(error),
                          );
                        },
                      ),
                    ),
                    InitialsSubmitButton(
                      onPressed: () {
                        _onSubmit(context);
                        context
                            .read<AudioController>()
                            .playSfx(Assets.music.startButton1);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
