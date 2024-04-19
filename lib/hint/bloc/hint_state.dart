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
    this.status = HintStatus.initial,
  });

  final HintStatus status;

  HintState copyWith({
    HintStatus? status,
  }) {
    return HintState(
      status: status ?? this.status,
    );
  }

  bool get isHintModeActive =>
      status == HintStatus.asking ||
      status == HintStatus.thinking ||
      status == HintStatus.invalid;

  @override
  List<Object> get props => [status];
}
