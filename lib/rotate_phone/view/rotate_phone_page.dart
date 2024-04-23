import 'package:flutter/material.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class RotatePhonePage extends StatelessWidget {
  const RotatePhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IoCrosswordColors.accessibleBlack,
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: IoCrosswordSpacing.lg),
          child: Text(
            context.l10n.rotatePhoneToPortraitMessage,
            style: const TextStyle(color: IoCrosswordColors.seedWhite),
          ),
        ),
      ),
    );
  }
}
