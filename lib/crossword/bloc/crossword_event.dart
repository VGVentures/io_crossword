part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

/// Requests a chunk of the board to be loaded.
///
/// It keeps listening for changes on the chunk even after it's loaded.
///
/// Consecutive requests for the same chunk are ignored, since the chunk
/// is already loaded and listened to.
// TODO(any): Consider adding the ability to stop listenting for a chunk,
// to save resources when the chunk is not longer visible.
// https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6487173469
class BoardSectionRequested extends CrosswordEvent {
  const BoardSectionRequested(this.position);

  final (int, int) position;

  @override
  List<Object> get props => [position];
}

@visibleForTesting
class BoardSectionLoaded extends CrosswordEvent {
  const BoardSectionLoaded(this.section);

  final BoardSection section;

  @override
  List<Object> get props => [section];
}

/// Pauses the active subscriptions from already loaded chunks that are not
/// currently needed.
///
/// The subscriptions might be resumed later on.
class LoadedSectionsSuspended extends CrosswordEvent {
  const LoadedSectionsSuspended(this.loadedSections);

  /// The current chunks that should be loaded and listened to.
  final Set<(int, int)> loadedSections;

  @override
  List<Object> get props => [loadedSections];
}

class WordSelected extends CrosswordEvent {
  const WordSelected(this.section, this.word);

  final (int, int) section;
  final Word word;

  @override
  List<Object> get props => [section, word];
}

class WordUnselected extends CrosswordEvent {
  const WordUnselected();

  @override
  List<Object> get props => [];
}

class BoardLoadingInformationRequested extends CrosswordEvent {
  const BoardLoadingInformationRequested();

  @override
  List<Object?> get props => [];
}
