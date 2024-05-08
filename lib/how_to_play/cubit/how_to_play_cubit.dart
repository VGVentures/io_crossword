import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'how_to_play_state.dart';

class HowToPlayCubit extends Cubit<HowToPlayState> {
  HowToPlayCubit() : super(const HowToPlayState());

  void updateIndex(int index) {
    emit(state.copyWith(index: index));
  }

  void updateStatus(HowToPlayStatus status) {
    emit(state.copyWith(status: status));
  }
}
