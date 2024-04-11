import 'package:bloc/bloc.dart';

class TeamSelectionCubit extends Cubit<int> {
  TeamSelectionCubit() : super(0);

  void selectTeam(int teamIndex) {
    emit(teamIndex);
  }
}
