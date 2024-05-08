part of 'loading_cubit.dart';

enum LoadingStatus {
  loading,
  loaded,
}

class LoadingState extends Equatable {
  const LoadingState({
    required this.status,
    required this.assetsCount,
    required this.loaded,
  });

  const LoadingState.initial()
      : this(
          status: LoadingStatus.loading,
          assetsCount: 0,
          loaded: 0,
        );

  final LoadingStatus status;

  final int assetsCount;

  final int loaded;

  int get progress => loaded == 0 ? 0 : ((loaded / assetsCount) * 100).ceil();

  LoadingState copyWith({
    LoadingStatus? status,
    int? assetsCount,
    int? loaded,
  }) {
    return LoadingState(
      status: status ?? this.status,
      assetsCount: assetsCount ?? this.assetsCount,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object> get props => [
        status,
        assetsCount,
        loaded,
      ];
}
