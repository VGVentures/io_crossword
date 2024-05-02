import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class CrosswordInput extends StatefulWidget {
  const CrosswordInput({
    required this.length,
    this.style,
    this.direction = Axis.horizontal,
    super.key,
  });

  final IoWordInputStyle? style;
  final int length;
  final Axis direction;

  @override
  State<CrosswordInput> createState() => _CrosswordInputState();
}

class _CrosswordInputState extends State<CrosswordInput> {
  final shakeKey = GlobalKey<ShakableState>();
  IoWordInputController? _controller;
  String _lastWord = '';

  void _onDelete() {
    if (_lastWord.length > _controller!.word.length) {
      context.read<WordSelectionBloc>().add(const WordSolveRequested());
    }
    _lastWord = _controller!.word;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller?.removeListener(_onDelete);
    _controller = DefaultWordInputController.of(context);
    _controller!.addListener(_onDelete);
  }

  @override
  void dispose() {
    _controller!.removeListener(_onDelete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordSelectionBloc, WordSelectionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == WordSelectionStatus.incorrect) {
          shakeKey.currentState?.shake();
        }
      },
      child: Shakable(
        key: shakeKey,
        shakeDuration: const Duration(milliseconds: 500),
        child: IoWordInput.alphabetic(
          controller: _controller,
          style: widget.style,
          direction: widget.direction,
          length: widget.length,
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
