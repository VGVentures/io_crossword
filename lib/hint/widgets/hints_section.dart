import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class HintsSection extends StatelessWidget {
  const HintsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final hintState = context.watch<HintBloc>().state;
    final isHintModeActive = hintState.isHintModeActive;
    final isThinking = hintState.status == HintStatus.thinking;
    final allHints = hintState.hints;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: HintText(
            text:
                isHintModeActive ? l10n.askYesOrNoQuestion : l10n.askGeminiHint,
          ),
        ),
        const SizedBox(height: 32),
        ...allHints.mapIndexed(
          (i, hint) => HintQuestionResponse(
            index: i,
            hint: hint,
          ),
        ),
        if (isThinking) ...[
          const SizedBox(height: 24),
          const Center(child: HintLoadingIndicator()),
        ],
      ],
    );
  }
}

@visibleForTesting
class HintQuestionResponse extends StatelessWidget {
  @visibleForTesting
  const HintQuestionResponse({
    required this.index,
    required this.hint,
    super.key,
  });

  final int index;
  final Hint hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final questionNumber = index + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Q$questionNumber: ${hint.question}',
          style: textTheme.bodySmall?.copyWith(
            color: IoCrosswordColors.softGray,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        HintText(text: hint.response.readable),
        const SizedBox(height: 8),
      ],
    );
  }
}

@visibleForTesting
class HintLoadingIndicator extends StatefulWidget {
  @visibleForTesting
  const HintLoadingIndicator({super.key});

  @override
  State<HintLoadingIndicator> createState() => _HintLoadingIndicatorState();
}

class _HintLoadingIndicatorState extends State<HintLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0, end: 1).animate(_controller),
      child: const GeminiIcon(size: 24),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
