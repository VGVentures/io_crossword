import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/game_intro/game_intro.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class MascotSelectionView extends StatelessWidget {
  const MascotSelectionView({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: MascotSelectionView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedMascot = context.select(
      (GameIntroBloc bloc) => bloc.state.selectedMascot,
    );

    return Scaffold(
      appBar: IoAppBar(
        crossword: l10n.crossword,
        actions: (context) {
          return const SizedBox();
        },
      ),
      body: CardScrollableContentWithButton(
        onPressed: () {
          context.read<GameIntroBloc>().add(const MascotSubmitted());
        },
        buttonLabel: l10n.continueLabel,
        child: Column(
          children: [
            Text(
              l10n.chooseTeam,
              style: IoCrosswordTextStyles.headlineMD,
            ),
            const SizedBox(height: 16),
            const Spacer(),
            ...Mascots.values.map(
              (mascot) => MascotItem(
                mascot: mascot,
                selectedMascot: selectedMascot,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class MascotItem extends StatelessWidget {
  const MascotItem({
    required this.mascot,
    required this.selectedMascot,
    super.key,
  });

  final Mascots mascot;
  final Mascots? selectedMascot;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(
        mascot.name,
        style: IoCrosswordTextStyles.titleMD,
      ),
      value: mascot,
      groupValue: selectedMascot,
      onChanged: (Mascots? value) {
        if (value != null) {
          context.read<GameIntroBloc>().add(MascotUpdated(value));
        }
      },
    );
  }
}
