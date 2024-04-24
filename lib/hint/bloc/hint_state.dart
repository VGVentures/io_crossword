part of 'hint_bloc.dart';

enum HintStatus {
  /// The user has not yet asked for a hint.
  initial,

  /// The user can ask for a hint.
  asking,

  /// The user has asked for a hint, and the hint is being retrieved.
  thinking,

  /// The hint has been retrieved and is ready to be displayed.
  answered,

  /// The hint could not be retrieved.
  ///
  /// Most likely, the question was not relevant or appropriate.
  invalid,
}

class HintState extends Equatable {
  const HintState({
    this.isHintsEnabled = false,
    this.status = HintStatus.initial,
    this.hints = const [],
    this.maxHints = 10,
  });

  final bool isHintsEnabled;
  final HintStatus status;
  final List<Hint> hints;
  final int maxHints;

  HintState copyWith({
    bool? isHintsEnabled,
    HintStatus? status,
    List<Hint>? hints,
    int? maxHints,
  }) {
    return HintState(
      isHintsEnabled: isHintsEnabled ?? this.isHintsEnabled,
      status: status ?? this.status,
      hints: hints ?? this.hints,
      maxHints: maxHints ?? this.maxHints,
    );
  }

  bool get isHintModeActive =>
      status == HintStatus.asking ||
      status == HintStatus.thinking ||
      status == HintStatus.invalid;

  int get hintsLeft => maxHints - hints.length;

  @override
  List<Object> get props => [isHintsEnabled, status, hints, maxHints];
}
