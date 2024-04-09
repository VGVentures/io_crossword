import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
    try {
      final [solved, total] = await Future.wait([
        _boardInfoRepository.getSolvedWordsCount(),
        _boardInfoRepository.getTotalWordsCount(),
      ]);

      emit(
        state.copyWith(
          solvedWords: solved,
          totalWords: total,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
