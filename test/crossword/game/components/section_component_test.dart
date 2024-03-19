import 'dart:async';
import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_network_assets/flame_network_assets.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordBloc extends Mock implements CrosswordBloc {}

class _MockFlameNetworkImages extends Mock implements FlameNetworkImages {}

class FakeImage extends Fake implements ui.Image {
  @override
  int get width => 100;

  @override
  int get height => 100;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SectionComponent', () {
    late FlameNetworkImages flameNetworkImages;
    late CrosswordBloc bloc;

    void mockState(CrosswordState state) {
      whenListen(
        bloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      flameNetworkImages = _MockFlameNetworkImages();
      bloc = _MockCrosswordBloc();

      const state = CrosswordLoaded(
        sectionSize: 400,
        sections: {},
      );
      mockState(state);

      when(
        () => flameNetworkImages.load(any()),
      ).thenAnswer((_) async => FakeImage());
    });

    CrosswordGame createGame({bool? showDebugOverlay}) => CrosswordGame(
          bloc,
          showDebugOverlay: showDebugOverlay,
          networkImages: flameNetworkImages,
        );

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
      'adds debug components when the game is showing debug overlay',
      () => createGame(showDebugOverlay: true),
      (game) async {
        final section = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(section);

        expect(section.firstChild<SectionDebugIndex>(), isNotNull);
        expect(section.firstChild<SectionDebugOutline>(), isNotNull);
      },
    );

    testWithGame(
      'automatically build the words when the section is already loaded',
      createGame,
      (game) async {
        mockState(
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: 400,
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
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
      'build the words with letters when the section is already loaded and'
      ' contains word with resolveTimestamp not null',
      createGame,
      (game) async {
        mockState(
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: 400,
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: 1,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
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

        expect(
          spriteBatch?.sources.any((element) => element.left != 1040),
          isTrue,
        );
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
            sectionSize: 400,
            sections: {},
          ),
        );
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        var spriteBatchComponent = component.firstChild<SpriteBatchComponent>();

        expect(spriteBatchComponent, isNull);
        streamController.add(
          CrosswordLoaded(
            sectionSize: 400,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: 400,
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
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
      'loads the section in snapshot mode when the state changes and the '
      'section is present',
      createGame,
      (game) async {
        final streamController = StreamController<CrosswordState>.broadcast();
        when(() => bloc.stream).thenAnswer((_) => streamController.stream);
        when(() => bloc.state).thenReturn(
          const CrosswordLoaded(
            sectionSize: 400,
            sections: {},
          ),
        );
        final component = SectionComponent(index: (100, 100));
        await game.world.ensureAdd(component);

        var spriteComponent = component.firstChild<SpriteComponent>();

        expect(spriteComponent, isNull);
        streamController.add(
          CrosswordLoaded(
            sectionSize: 400,
            renderMode: RenderMode.snapshot,
            sections: {
              (100, 100): BoardSection(
                id: '',
                position: const Point(100, 100),
                size: 400,
                snapshotUrl: 'snapshotUrl',
                words: [
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.vertical,
                    answer: 'Flutter',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                  Word(
                    position: const Point(0, 0),
                    axis: Axis.horizontal,
                    answer: 'Firebase',
                    clue: '',
                    hints: const [],
                    solvedTimestamp: null,
                  ),
                ],
                borderWords: const [],
              ),
            },
          ),
        );

        await game.ready();

        spriteComponent = component.firstChild<SpriteComponent>();
        expect(spriteComponent, isNotNull);

        final sprite = spriteComponent?.sprite;
        expect(sprite, isNotNull);
      },
    );

    testWithGame(
      'adds a BoardSectionRequested when the section is not loaded yet',
      createGame,
      (game) async {
        await game.world.ensureAdd(SectionComponent(index: (100, 100)));

        verify(
          () => bloc.add(
            const BoardSectionRequested((100, 100)),
          ),
        ).called(1);
      },
    );

    testWithGame(
      'switches rendering from game to snapshot',
      createGame,
      (game) async {
        final streamController = StreamController<CrosswordState>.broadcast();
        final state = CrosswordLoaded(
          sectionSize: 400,
          sections: {
            (0, 0): BoardSection(
              id: '',
              position: const Point(0, 0),
              size: 400,
              words: [
                Word(
                  position: const Point(1, 0),
                  axis: Axis.vertical,
                  answer: 'Flutter',
                  clue: '',
                  hints: const [],
                  solvedTimestamp: null,
                ),
                Word(
                  position: const Point(0, 0),
                  axis: Axis.horizontal,
                  answer: 'Firebase',
                  clue: '',
                  hints: const [],
                  solvedTimestamp: null,
                ),
              ],
              snapshotUrl: 'snapshotUrl',
              borderWords: const [],
            ),
          },
        );
        when(() => bloc.state).thenReturn(state);
        whenListen(bloc, streamController.stream, initialState: state);
        await game.ready();

        streamController.add(
          state.copyWith(
            renderMode: RenderMode.snapshot,
          ),
        );

        await Future.microtask(() {});
        await Future.microtask(() {});
        game.update(0);

        verify(() => flameNetworkImages.load(any())).called(1);

        final sectionComponent = game.world.children
            .whereType<SectionComponent>()
            .firstWhere((element) => element.index == (0, 0));
        expect(sectionComponent, isNotNull);

        final spriteBatchComponent =
            sectionComponent.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNull);

        final spriteComponent = sectionComponent.firstChild<SpriteComponent>();
        expect(spriteComponent, isNotNull);
      },
    );

    testWithGame(
      'switches rendering from snapshot to game',
      createGame,
      (game) async {
        final streamController = StreamController<CrosswordState>.broadcast();
        final state = CrosswordLoaded(
          sectionSize: 400,
          renderMode: RenderMode.snapshot,
          sections: {
            (0, 0): BoardSection(
              id: '',
              position: const Point(0, 0),
              size: 400,
              words: [
                Word(
                  position: const Point(1, 0),
                  axis: Axis.vertical,
                  answer: 'Flutter',
                  clue: '',
                  hints: const [],
                  solvedTimestamp: null,
                ),
                Word(
                  position: const Point(0, 0),
                  axis: Axis.horizontal,
                  answer: 'Firebase',
                  clue: '',
                  hints: const [],
                  solvedTimestamp: null,
                ),
              ],
              snapshotUrl: 'snapshotUrl',
              borderWords: const [],
            ),
          },
        );
        when(() => bloc.state).thenReturn(state);
        whenListen(bloc, streamController.stream, initialState: state);
        await game.ready();

        streamController.add(
          state.copyWith(
            renderMode: RenderMode.game,
          ),
        );

        await Future.microtask(() {});
        await Future.microtask(() {});
        game.update(0);

        final sectionComponent = game.world.children
            .whereType<SectionComponent>()
            .firstWhere((element) => element.index == (0, 0));
        expect(sectionComponent, isNotNull);

        final spriteBatchComponent =
            sectionComponent.firstChild<SpriteBatchComponent>();
        expect(spriteBatchComponent, isNotNull);

        final spriteComponent = sectionComponent.firstChild<SpriteComponent>();
        expect(spriteComponent, isNull);
      },
    );
  });
}
