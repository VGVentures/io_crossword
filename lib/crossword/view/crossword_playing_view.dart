import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:io_crossword/bottom_bar/bottom_bar.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

/// {@template crossword_playing_view}
/// Displays the crossword, in its playing state.
///
/// The user cannot interact with the crossword while the mascot animation is
/// playing.
/// {@endtemplate}
class CrosswordPlayingView extends StatelessWidget {
  const CrosswordPlayingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultWordInputController(
      child: Stack(
        children: [
          BlocSelector<CrosswordBloc, CrosswordState, bool>(
            selector: (state) => state.mascotVisible,
            builder: (context, mascotVisible) {
              return IgnorePointer(
                ignoring: mascotVisible,
                child: const CrosswordBoardView(),
              );
            },
          ),
          const BottomBar(),
          const WordSelectionPage(),
        ],
      ),
    );
  }
}
