import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/extensions/extensions.dart';

void main() {
  test('Formatting numbers less than 1000', () {
    expect(0.toDisplayNumber(), equals('0'));
    expect(500.toDisplayNumber(), equals('500'));
    expect(999.toDisplayNumber(), equals('999'));
  });

  test('Formatting numbers between 1000 and 999999', () {
    expect(1000.toDisplayNumber(), equals('1K'));
    expect(1500.toDisplayNumber(), equals('1.5K'));
    expect(999950.toDisplayNumber(), equals('1M'));
    expect(999999.toDisplayNumber(), equals('1M'));
  });

  test('Formatting numbers between 1000000 and 999999999', () {
    expect(1000000.toDisplayNumber(), equals('1M'));
    expect(1500000.toDisplayNumber(), equals('1.5M'));
    expect(999950000.toDisplayNumber(), equals('1B'));
    expect(999999999.toDisplayNumber(), equals('1B'));
  });

  test('Formatting numbers greater than or equal to 1000000000', () {
    expect(1000000000.toDisplayNumber(), equals('1B'));
    expect(1500000000.toDisplayNumber(), equals('1.5B'));
    expect(9999999999.toDisplayNumber(), equals('10B'));
  });
}
