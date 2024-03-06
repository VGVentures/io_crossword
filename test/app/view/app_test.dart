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
        () => crosswordRepository.watchSectionFromPosition(any()),
      ).thenAnswer((_) => Stream.value(null));
    });
    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(
          crosswordRepository: _MockCrosswordRepository(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 700));
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
