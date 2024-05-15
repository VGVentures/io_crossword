import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockIoWordTheme extends Mock implements IoWordTheme {}

class _MockIoCrosswordTextStyles extends Mock
    implements IoCrosswordTextStyles {}

class _MockIoIconButtonTheme extends Mock implements IoIconButtonTheme {}

class _MockIoCardTheme extends Mock implements IoCardTheme {}

class _MockIoPhysicalModelStyle extends Mock implements IoPhysicalModelStyle {}

class _MockIoWordInputTheme extends Mock implements IoWordInputTheme {}

class _MockIoColorScheme extends Mock implements IoColorScheme {}

class _MockIoOutlineButtonTheme extends Mock implements IoOutlineButtonTheme {}

class _MockIoCrosswordLetterTheme extends Mock
    implements IoCrosswordLetterTheme {}

void main() {
  group('$IoThemeExtension', () {
    group('copyWith', () {
      test('remains the same when no arguments are give', () {
        final theme = IoThemeExtension(
          wordTheme: _MockIoWordTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          wordInput: _MockIoWordInputTheme(),
          colorScheme: _MockIoColorScheme(),
          outlineButtonTheme: _MockIoOutlineButtonTheme(),
          crosswordLetterTheme: _MockIoCrosswordLetterTheme(),
          textStyles: _MockIoCrosswordTextStyles(),
        );

        final newTheme = theme.copyWith();

        expect(newTheme, equals(theme));
      });

      test('changes when arguments are give', () {
        final theme = IoThemeExtension(
          wordTheme: _MockIoWordTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          wordInput: _MockIoWordInputTheme(),
          colorScheme: _MockIoColorScheme(),
          outlineButtonTheme: _MockIoOutlineButtonTheme(),
          crosswordLetterTheme: _MockIoCrosswordLetterTheme(),
          textStyles: _MockIoCrosswordTextStyles(),
        );

        final newTheme = theme.copyWith(
          wordTheme: _MockIoWordTheme(),
        );

        expect(newTheme, isNot(equals(theme)));
      });
    });

    group('lerp', () {
      test('returns itself when other is null', () {
        final theme = IoThemeExtension(
          wordTheme: _MockIoWordTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          wordInput: _MockIoWordInputTheme(),
          colorScheme: _MockIoColorScheme(),
          outlineButtonTheme: _MockIoOutlineButtonTheme(),
          crosswordLetterTheme: _MockIoCrosswordLetterTheme(),
          textStyles: _MockIoCrosswordTextStyles(),
        );

        final newTheme = theme.lerp(null, 0.5);

        expect(newTheme, equals(theme));
      });

      test('returns a lerp of the two themes', () {
        final theme = IoThemeExtension(
          wordTheme: _MockIoWordTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          wordInput: _MockIoWordInputTheme(),
          colorScheme: _MockIoColorScheme(),
          outlineButtonTheme: _MockIoOutlineButtonTheme(),
          crosswordLetterTheme: _MockIoCrosswordLetterTheme(),
          textStyles: _MockIoCrosswordTextStyles(),
        );

        when(
          () => theme.wordTheme.lerp(theme.wordTheme, 0.5),
        ).thenReturn(_MockIoWordTheme());
        when(
          () => theme.iconButtonTheme.lerp(theme.iconButtonTheme, 0.5),
        ).thenReturn(_MockIoIconButtonTheme());
        when(
          () => theme.cardTheme.lerp(theme.cardTheme, 0.5),
        ).thenReturn(_MockIoCardTheme());
        when(
          () => theme.physicalModel.lerp(theme.physicalModel, 0.5),
        ).thenReturn(_MockIoPhysicalModelStyle());
        when(
          () => theme.wordInput.lerp(theme.wordInput, 0.5),
        ).thenReturn(_MockIoWordInputTheme());
        when(
          () => theme.colorScheme.lerp(theme.colorScheme, 0.5),
        ).thenReturn(_MockIoColorScheme());
        when(
          () => theme.outlineButtonTheme.lerp(theme.outlineButtonTheme, 0.5),
        ).thenReturn(_MockIoOutlineButtonTheme());
        when(
          () =>
              theme.crosswordLetterTheme.lerp(theme.crosswordLetterTheme, 0.5),
        ).thenReturn(_MockIoCrosswordLetterTheme());

        final newTheme = theme.lerp(theme, 0.5);

        expect(newTheme, isNot(equals(theme)));
      });
    });
  });

  group('ExtendedThemeData', () {
    group('io', () {
      test('throws an $AssertionError when not found', () {
        final themeData = ThemeData();

        expect(
          () => themeData.io,
          throwsA(
            isA<AssertionError>().having(
              (error) => error.message,
              'message',
              equals('$IoThemeExtension not found in $ThemeData'),
            ),
          ),
        );
      });

      test('returns the $IoThemeExtension', () {
        final themeData = ThemeData(
          extensions: [
            IoThemeExtension(
              wordTheme: _MockIoWordTheme(),
              iconButtonTheme: _MockIoIconButtonTheme(),
              cardTheme: _MockIoCardTheme(),
              physicalModel: _MockIoPhysicalModelStyle(),
              wordInput: _MockIoWordInputTheme(),
              colorScheme: _MockIoColorScheme(),
              outlineButtonTheme: _MockIoOutlineButtonTheme(),
              crosswordLetterTheme: _MockIoCrosswordLetterTheme(),
              textStyles: _MockIoCrosswordTextStyles(),
            ),
          ],
        );

        expect(themeData.io, isA<IoThemeExtension>());
      });
    });
  });
}
