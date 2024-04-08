import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc({
    required BoardInfoRepository boardInfoRepository,
  })  : _boardInfoRepository = boardInfoRepository,
        super(const WelcomeState.initial()) {
    on<WelcomeDataRequested>(_onDataRequested);
  }

  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onDataRequested(
    WelcomeDataRequested event,
    Emitter<WelcomeState> emit,
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
