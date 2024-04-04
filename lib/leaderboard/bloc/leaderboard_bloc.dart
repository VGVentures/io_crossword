import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc() : super(LeaderboardInitial()) {
    on<LeaderboardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
