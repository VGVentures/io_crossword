import 'package:bloc/bloc.dart';

class HowToPlayCubit extends Cubit<int> {
  HowToPlayCubit() : super(0);

  void updateIndex(int index) {
    emit(index);
  }
}
