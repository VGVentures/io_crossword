import 'package:bloc_test/bloc_test.dart';
import 'package:flame/events.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CrosswordGame', () {
    late CrosswordBloc bloc;

    void mockState(CrosswordState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      bloc = _MockCrosswordBloc();

      const state = CrosswordLoaded(
        width: 40,
        height: 40,
        sectionSize: 400,
        sections: {},
      );
      mockState(state);
    });

    CrosswordGame createGame() => CrosswordGame(bloc);

    testWithGame(
      'loads',
      createGame,
      (game) async {
        await game.ready();
        expect(
          game.world.children.whereType<SectionComponent>(),
          isNotEmpty,
        );
      },
    );

    test(
        'throws ArgumentError when accessing the state in the wrong '
        'status', () {
      mockState(const CrosswordInitial());
      final game = createGame();

      expect(() => game.state, throwsArgumentError);
    });

    testWithGame(
      'remove sections that are not visible when paning',
      () {
        const state = CrosswordLoaded(
          width: 40,
          height: 40,
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '',
              position: Point(2, 2),
              width: 400,
              height: 400,
              words: [],
            ),
          },
        );
        mockState(state);
        return createGame();
      },
      (game) async {
        await game.ready();
        final currentSections =
            game.world.children.whereType<SectionComponent>();

        final subjectComponent =
            currentSections.firstWhere((element) => element.index == (2, 2));

        final removed = subjectComponent.removed;

        game
          ..onPanUpdate(
            DragUpdateInfo.fromDetails(
              game,
              DragUpdateDetails(
                globalPosition: Offset.zero,
                localPosition: Offset.zero,
                delta: const Offset(2400, 30),
              ),
            ),
          )
          ..update(0);

        expect(removed, completes);
      },
    );
  });
}
