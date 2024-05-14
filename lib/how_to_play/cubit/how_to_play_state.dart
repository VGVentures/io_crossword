part of 'how_to_play_cubit.dart';

enum HowToPlayStatus {
  idle,
  pickingUp,
  complete,
}

enum AssetsLoadingStatus {
  inProgress,
  success,
}

class HowToPlayState extends Equatable {
  const HowToPlayState({
    this.index = 0,
    this.status = HowToPlayStatus.idle,
    this.assetsStatus = AssetsLoadingStatus.inProgress,
  });

  final int index;

  final HowToPlayStatus status;

  final AssetsLoadingStatus assetsStatus;

  HowToPlayState copyWith({
    int? index,
    HowToPlayStatus? status,
    AssetsLoadingStatus? assetsStatus,
  }) {
    return HowToPlayState(
      index: index ?? this.index,
      status: status ?? this.status,
      assetsStatus: assetsStatus ?? this.assetsStatus,
    );
  }

  @override
  List<Object> get props => [
        index,
        status,
        assetsStatus,
      ];
}
