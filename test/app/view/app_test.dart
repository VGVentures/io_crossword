// ignore_for_file: prefer_const_constructors

import 'dart:math';

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
        () => crosswordRepository.watchSectionFromPosition(Point(0, 0)),
      ).thenAnswer((_) => Stream.value(null));
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          crosswordRepository: crosswordRepository,
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
