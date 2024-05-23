import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/audio/audio.dart';
import 'package:io_crossword/how_to_play/how_to_play.dart';
import 'package:io_crossword/player/player.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockHowToPlayCubit extends MockCubit<HowToPlayState>
    implements HowToPlayCubit {}

class _MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState>
    implements PlayerBloc {}

class _MockAudioController extends Mock implements AudioController {}

void main() {
  group('$PlayNowButton', () {
    late HowToPlayCubit howToPlayCubit;
    late PlayerBloc playerBloc;
    late AudioController audioController;

    setUp(() {
      howToPlayCubit = _MockHowToPlayCubit();

      playerBloc = _MockPlayerBloc();
      when(() => playerBloc.state).thenReturn(
        const PlayerState(
          player: Player(
            id: '1',
            initials: 'AAA',
            mascot: Mascots.dash,
          ),
        ),
      );

      audioController = _MockAudioController();
    });

    testWidgets(
      'emits $PlayerCreateScoreRequested when pressed',
      (tester) async {
        await tester.pumpApp(
          playerBloc: playerBloc,
          audioController: audioController,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: howToPlayCubit),
            ],
            child: const PlayNowButton(),
          ),
        );

        await tester.tap(find.byType(PlayNowButton));

        verify(() => playerBloc.add(const PlayerCreateScoreRequested()))
            .called(1);
      },
    );

    testWidgets(
      'plays ${Assets.music.startButton1} when pressed',
      (tester) async {
        await tester.pumpApp(
          playerBloc: playerBloc,
          audioController: audioController,
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: howToPlayCubit),
            ],
            child: const PlayNowButton(),
          ),
        );

        await tester.tap(find.byType(PlayNowButton));

        verify(
          () => audioController.playSfx(Assets.music.startButton1),
        ).called(1);
      },
    );

    testWidgets('updates pickingUp status when pressed', (tester) async {
      await tester.pumpApp(
        playerBloc: playerBloc,
        audioController: audioController,
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: howToPlayCubit),
          ],
          child: const PlayNowButton(),
        ),
      );
      await tester.tap(find.byType(PlayNowButton));

      verify(() => howToPlayCubit.updateStatus(HowToPlayStatus.pickingUp))
          .called(1);
    });
  });
}
