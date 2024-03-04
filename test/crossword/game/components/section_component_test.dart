import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SectionComponent', () {
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
        await game.world.ensureAdd(SectionComponent(index: (100, 100)));
        expect(
          game.world.children.whereType<SectionComponent>().where(
                (element) => element.index == (100, 100),
              ),
          hasLength(1),
        );
      },
    );

    testWithGame(
      'automatically build the words when the section is already loaded',
      createGame,
      (game) async {
        mockState(
          const CrosswordLoaded(
            width: 40,
            height: 40,
            sectionSize: 400,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: Point(100, 100),
                size: 400,
                words: [
                  Word(
                    id: '',
                    position: Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: [],
                    visible: true,
                    solvedTimestamp: null,
                  ),
                  Word(
                    id: '',
                    position: Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: [],
                    visible: true,
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: [],
              ),
            },
          ),
        );
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        final spriteBatchComponent =
            component.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8
        expect(spriteBatch?.sources, hasLength(15));
      },
    );

    testWithGame(
      'loads the section in the component when the state changes and the '
      'section is present',
      createGame,
      (game) async {
        final streamController = StreamController<CrosswordState>.broadcast();
        when(() => bloc.stream).thenAnswer((_) => streamController.stream);
        when(() => bloc.state).thenReturn(
          const CrosswordLoaded(
            width: 40,
            height: 40,
            sectionSize: 400,
            sections: {},
          ),
        );
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        var spriteBatchComponent = component.firstChild<SpriteBatchComponent>();

        expect(spriteBatchComponent, isNull);
        streamController.add(
          const CrosswordLoaded(
            width: 40,
            height: 40,
            sectionSize: 400,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: Point(100, 100),
                size: 400,
                words: [
                  Word(
                    id: '',
                    position: Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: [],
                    visible: true,
                    solvedTimestamp: null,
                  ),
                  Word(
                    id: '',
                    position: Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: [],
                    visible: true,
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: [],
              ),
            },
          ),
        );

        await game.ready();

        spriteBatchComponent = component.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteBatch = spriteBatchComponent?.spriteBatch;
        expect(spriteBatch, isNotNull);
        // 15 because Flutter has 7 letters and Firebase has 8
        expect(spriteBatch?.sources, hasLength(15));
      },
    );

    testWithGame(
      'adds a BoardSectionRequested when the section is not loaded yet',
      createGame,
      (game) async {
        await game.world.ensureAdd(SectionComponent(index: (100, 100)));

        verify(
          () => bloc.add(
            const BoardSectionRequested((1, 1)),
          ),
        ).called(1);
      },
    );
  });
}
