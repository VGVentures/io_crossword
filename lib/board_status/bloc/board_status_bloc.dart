import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';

part 'board_status_event.dart';
part 'board_status_state.dart';

class BoardStatusBloc extends Bloc<BoardStatusEvent, BoardStatusState> {
  BoardStatusBloc({
    required BoardInfoRepository boardInfoRepository,
  })  : _boardInfoRepository = boardInfoRepository,
        super(const BoardStatusInitial()) {
    on<BoardStatusRequested>(_onStatusRequested);
  }

  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onStatusRequested(
    BoardStatusRequested event,
    Emitter<BoardStatusState> emit,
  ) async {
    return emit.forEach(
      _boardInfoRepository.getGameStatus(),
      onData: (status) {
        if (status == GameStatus.resetInProgress) {
          return const BoardStatusResetInProgress();
        }

        return const BoardStatusInProgress();
      },
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return const BoardStatusFailure();
      },
    );
  }
}
