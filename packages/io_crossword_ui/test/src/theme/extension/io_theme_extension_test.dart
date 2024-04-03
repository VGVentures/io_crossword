import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockIoPlayerAliasTheme extends Mock implements IoPlayerAliasTheme {}

class _MockIoIconButtonTheme extends Mock implements IoIconButtonTheme {}

class _MockIoCardTheme extends Mock implements IoCardTheme {}

class _MockIoPhysicalModelStyle extends Mock implements IoPhysicalModelStyle {}

class _MockIoTextInputStyle extends Mock implements IoTextInputStyle {}

void main() {
  group('$IoThemeExtension', () {
    group('copyWith', () {
      test('remains the same when no arguments are give', () {
        final theme = IoThemeExtension(
          playerAliasTheme: _MockIoPlayerAliasTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          textInput: _MockIoTextInputStyle(),
        );

        final newTheme = theme.copyWith();

        expect(newTheme, equals(theme));
      });

      test('changes when arguments are give', () {
        final theme = IoThemeExtension(
          playerAliasTheme: _MockIoPlayerAliasTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          textInput: _MockIoTextInputStyle(),
        );

        final newTheme = theme.copyWith(
          playerAliasTheme: _MockIoPlayerAliasTheme(),
        );

        expect(newTheme, isNot(equals(theme)));
      });
    });

    group('lerp', () {
      test('returns itself when other is null', () {
        final theme = IoThemeExtension(
          playerAliasTheme: _MockIoPlayerAliasTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          textInput: _MockIoTextInputStyle(),
        );

        final newTheme = theme.lerp(null, 0.5);

        expect(newTheme, equals(theme));
      });

      test('returns a lerp of the two themes', () {
        final theme = IoThemeExtension(
          playerAliasTheme: _MockIoPlayerAliasTheme(),
          iconButtonTheme: _MockIoIconButtonTheme(),
          cardTheme: _MockIoCardTheme(),
          physicalModel: _MockIoPhysicalModelStyle(),
          textInput: _MockIoTextInputStyle(),
        );

        when(
          () => theme.playerAliasTheme.lerp(theme.playerAliasTheme, 0.5),
        ).thenReturn(_MockIoPlayerAliasTheme());
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
          () => theme.textInput.lerp(theme.textInput, 0.5),
        ).thenReturn(_MockIoTextInputStyle());

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
              playerAliasTheme: _MockIoPlayerAliasTheme(),
              iconButtonTheme: _MockIoIconButtonTheme(),
              cardTheme: _MockIoCardTheme(),
              physicalModel: _MockIoPhysicalModelStyle(),
              textInput: _MockIoTextInputStyle(),
            ),
          ],
        );

        expect(themeData.io, isA<IoThemeExtension>());
      });
    });
  });
}
