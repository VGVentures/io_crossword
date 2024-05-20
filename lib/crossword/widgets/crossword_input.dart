import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordInput extends StatefulWidget {
  const CrosswordInput({
    required this.length,
    required this.characters,
    this.style,
    this.direction = Axis.horizontal,
    @visibleForTesting AnimationController? animationController,
    super.key,
  }) : _animationController = animationController;

  final IoWordInputStyle? style;
  final int length;
  final Axis direction;
  final Map<int, String>? characters;

  final AnimationController? _animationController;

  @override
  State<CrosswordInput> createState() => _CrosswordInputState();
}

class _CrosswordInputState extends State<CrosswordInput>
    with SingleTickerProviderStateMixin {
  IoWordInputController? _wordInputController;
  late final AnimationController _animationController =
      widget._animationController ??
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          );

  String _lastWord = '';

  void _onNewLetter() {
    if (_lastWord.isEmpty &&
        (_lastWord.length < _wordInputController!.word.length)) {
      context.read<WordSelectionBloc>().add(const WordSolveRequested());
    }
    _lastWord = _wordInputController!.word;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _wordInputController?.removeListener(_onNewLetter);
    _wordInputController = DefaultWordInputController.of(context);
    _wordInputController!.addListener(_onNewLetter);
  }

  @override
  void dispose() {
    _wordInputController!.removeListener(_onNewLetter);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = context.select((WordSelectionBloc bloc) {
      final status = bloc.state.status;

      return status == WordSelectionStatus.empty ||
          status == WordSelectionStatus.preSolving;
    });

    return BlocListener<WordSelectionBloc, WordSelectionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == WordSelectionStatus.incorrect) {
          _animationController.forward(from: 0);
        }
      },
      child: Shakable(
        controller: _animationController,
        child: IoWordInput.alphabetic(
          readOnly: readOnly,
          controller: _wordInputController,
          style: widget.style,
          direction: widget.direction,
          length: widget.length,
          characters: widget.characters,
          onSubmit: (value) {
            context
                .read<WordSelectionBloc>()
                .add(WordSolveAttempted(answer: value));
          },
        ),
      ),
    );
  }
}
