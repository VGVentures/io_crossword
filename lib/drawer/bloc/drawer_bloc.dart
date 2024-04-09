import 'package:bloc/bloc.dart';
import 'package:board_info_repository/board_info_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc({
    required BoardInfoRepository boardInfoRepository,
  })  : _boardInfoRepository = boardInfoRepository,
        super(const DrawerState.initial()) {
    on<RecordDataRequested>(_onRecordStatusRequested);
  }

  final BoardInfoRepository _boardInfoRepository;

  Future<void> _onRecordStatusRequested(
    RecordDataRequested event,
    Emitter<DrawerState> emit,
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
