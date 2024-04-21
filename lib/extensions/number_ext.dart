import 'package:intl/intl.dart';

extension NumberExtension on int {
  String toDisplayNumber() {
    return NumberFormat.compact().format(this);
  }
}
