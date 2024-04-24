import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/assets/assets.dart';
import 'package:io_crossword/welcome/widgets/welcome_header_image.dart';

void main() {
  group('$WelcomeHeaderImage', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(const WelcomeHeaderImage());

      expect(find.byType(WelcomeHeaderImage), findsOneWidget);
    });

    testWidgets('displays the welcome background image', (tester) async {
      await tester.pumpWidget(const WelcomeHeaderImage());

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      expect(
        tester.widget<Image>(imageFinder),
        isA<Image>().having(
          (image) => (image.image as AssetImage).assetName,
          'assetName',
          equals(Assets.images.welcomeBackground.path),
        ),
      );
    });

    testWidgets('sizes with the preferredSize', (tester) async {
      const subject = WelcomeHeaderImage();
      await tester.pumpWidget(const Align(child: subject));

      final size = tester.getSize(find.byType(WelcomeHeaderImage));
      expect(size.height, equals(subject.preferredSize.height));
      expect(size.width, isNot(greaterThan(subject.preferredSize.width)));
    });
  });
}
