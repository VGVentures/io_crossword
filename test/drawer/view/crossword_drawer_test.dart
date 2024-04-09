// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/drawer/view/crossword_drawer.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CrosswordDrawer', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(CrosswordDrawer());

      expect(find.byType(CrosswordDrawerView), findsOneWidget);
    });
  });
}
