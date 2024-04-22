import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/hint/hint.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class GeminiTextField extends StatefulWidget {
  const GeminiTextField({
    super.key,
  });

  @override
  State<GeminiTextField> createState() => _GeminiTextFieldState();
}

class _GeminiTextFieldState extends State<GeminiTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _onAskForHint(BuildContext context, String question) {
    final wordId = context.read<WordSelectionBloc>().state.word?.word.id;
    final hintBloc = context.read<HintBloc>();

    if (wordId == null) return;
    if (question.isEmpty) return;
    if (hintBloc.state.status == HintStatus.thinking) return;

    hintBloc.add(HintRequested(wordId: wordId, question: question));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: IoCrosswordTheme.geminiInputDecorationTheme,
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        decoration: InputDecoration(
          hintText: l10n.type,
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 6),
            child: GeminiIcon(),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GeminiGradient(
              child: IconButton(
                onPressed: () => _onAskForHint(context, _controller.text),
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        ),
        onSubmitted: (_) => _onAskForHint(context, _controller.text),
      ),
    );
  }
}
