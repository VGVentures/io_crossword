part of 'how_to_play_cubit.dart';

enum HowToPlayStatus {
  idle,
  pickingUp,
}

class HowToPlayState extends Equatable {
  const HowToPlayState({
    this.index = 0,
    this.status = HowToPlayStatus.idle,
  });

  final int index;

  final HowToPlayStatus status;

  HowToPlayState copyWith({
    int? index,
    HowToPlayStatus? status,
  }) {
    return HowToPlayState(
      index: index ?? this.index,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        index,
        status,
      ];
}
