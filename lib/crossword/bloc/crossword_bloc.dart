import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:game_domain/game_domain.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

typedef ImageDecodeCall = Future<ui.Image> Function(Uint8List);

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc({
    required CrosswordRepository crosswordRepository,
    ImageDecodeCall? imageDecodeCall,
  })  : _crosswordRepository = crosswordRepository,
        _imageDecodeCall = imageDecodeCall ?? decodeImageFromList,
        super(const CrosswordInitial()) {
    on<BoardSectionRequested>(_onBoardSectionRequested);
    on<WordSelected>(_onWordSelected);
    on<RenderModeSwitched>(_onRenderModeSwitched);
  }

  final CrosswordRepository _crosswordRepository;
  final ImageDecodeCall _imageDecodeCall;

  Future<void> _onBoardSectionRequested(
    BoardSectionRequested event,
    Emitter<CrosswordState> emit,
  ) async {
    return emit.forEach(
      _crosswordRepository.watchSectionFromPosition(
        event.position.$1,
        event.position.$2,
      ),
      onData: (section) {
        if (section == null) return state;
        final newSection = {
          (section.position.x, section.position.y): section,
        };

        return CrosswordLoaded(
          sectionSize: section.size,
          sections: state is CrosswordLoaded
              ? {
                  ...(state as CrosswordLoaded).sections,
                  ...newSection,
                }
              : {...newSection},
        );
      },
    );
  }

  (int, int) _findWordInSection(
    CrosswordLoaded state,
    Word word,
    (int, int) section, {
    int attempt = 1,
  }) {
    final sections = state.sections;

    // TODO(Ayad): If it fails because the section is not loaded we
    // should fetch the section
    if (sections[section]!.words.contains(word)) {
      return section;
    }

    // TODO(Ayad): control error handle
    if (attempt >= 3) {
      throw Exception('Word not found in crossword');
    }

    final previousSection = word.axis == Axis.horizontal
        ? (section.$1 - 1, section.$2)
        : (section.$1, section.$2 - 1);

    return _findWordInSection(
      state,
      word,
      previousSection,
      attempt: attempt + 1,
    );
  }

  FutureOr<void> _onWordSelected(
    WordSelected event,
    Emitter<CrosswordState> emit,
  ) {
    final currentState = state;
    if (currentState is CrosswordLoaded) {
      final section = _findWordInSection(
        currentState,
        event.word,
        event.section,
      );

      emit(
        currentState.copyWith(
          selectedWord: WordSelection(
            section: section,
            wordId: event.word.id,
          ),
        ),
      );
    }
  }

  Future<void> _onRenderModeSwitched(
    RenderModeSwitched event,
    Emitter<CrosswordState> emit,
  ) async {
    if (state is CrosswordLoaded) {
      var loadedState = state as CrosswordLoaded;

      if (event.renderMode == RenderMode.snapshot) {
        final sectionsWithSnapshot = loadedState.sections.values
            .where((section) => section.snapshotUrl != null);

        for (final section in sectionsWithSnapshot) {
          final bytes = await _crosswordRepository.fetchSectionSnapshotBytes(
            section.snapshotUrl!,
          );
          final image = await _imageDecodeCall(bytes);

          loadedState = loadedState.copyWith(
            sectionsSnapshots: {
              ...loadedState.sectionsSnapshots,
              (section.position.x, section.position.y): image,
            },
          );
        }
      }

      emit(
        loadedState.copyWith(
          renderMode: event.renderMode,
        ),
      );
    }
  }
}
