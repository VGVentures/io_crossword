// ignore_for_file: prefer_const_constructors

import 'package:crossword_repository/crossword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/app/app.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordRepository extends Mock implements CrosswordRepository {}

void main() {
  group('App', () {
    late CrosswordRepository crosswordRepository;

    setUp(() {
      crosswordRepository = _MockCrosswordRepository();

      when(
        () => crosswordRepository.watchSectionFromPosition(0, 0),
      ).thenAnswer((_) => Stream.value(null));
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          crosswordRepository: crosswordRepository,
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
