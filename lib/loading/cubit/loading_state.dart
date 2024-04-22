part of 'loading_cubit.dart';

class LoadingState extends Equatable {
  const LoadingState({
    required this.assetsCount,
    required this.loaded,
  });

  const LoadingState.initial() : this(assetsCount: 0, loaded: 0);

  final int assetsCount;

  final int loaded;

  int get progress => loaded == 0 ? 0 : ((loaded / assetsCount) * 100).ceil();

  LoadingState copyWith({
    int? assetsCount,
    int? loaded,
  }) {
    return LoadingState(
      assetsCount: assetsCount ?? this.assetsCount,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object> get props => [
        assetsCount,
        loaded,
      ];
}
