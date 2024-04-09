import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/music/music.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class InitialsInputView extends StatelessWidget {
  const InitialsInputView({super.key});

  static Page<void> page() {
    return const MaterialPage(child: InitialsInputView());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final initialsStatus =
        context.select((GameIntroBloc bloc) => bloc.state.initialsStatus);
    final isLoading = initialsStatus == InitialsFormStatus.loading;

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        actions: (context) {
          return const Row(
            children: [
              MuteButton(),
              SizedBox(width: 7),
              DrawerButton(),
            ],
          );
        },
      ),
      body: CardScrollableContentWithButton(
        onPressed: isLoading
            ? null
            : () {
                context.read<GameIntroBloc>().add(const InitialsSubmitted());
              },
        buttonLabel: l10n.enter,
        child: Column(
          children: [
            Text(
              l10n.enterInitials,
              style: IoCrosswordTextStyles.headlineMD,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Spacer(),
            const InitialsFormView(),
            const Spacer(flex: 4),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
