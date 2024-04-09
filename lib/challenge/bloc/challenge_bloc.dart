import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  ChallengeBloc({
    required BoardInfoRepository boardInfoRepository,
  })  : _boardInfoRepository = boardInfoRepository,
        super(const ChallengeState.initial()) {
    on<ChallengeDataRequested>(_onDataRequested);
  }

  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onDataRequested(
    ChallengeDataRequested event,
    Emitter<ChallengeState> emit,
  ) async {
    return emit.forEach(
      Rx.combineLatest2(
        _boardInfoRepository.getSolvedWordsCount(),
        _boardInfoRepository.getTotalWordsCount(),
        (solved, total) => state.copyWith(
          solvedWords: solved,
          totalWords: total,
        ),
      ),
      onData: (state) => state,
      onError: (error, stackTrace) {
        addError(error, stackTrace);
        return state;
      },
    );
  }
}
