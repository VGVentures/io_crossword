extension NumberExtension on int {
  String toDisplayNumber() {
    final number = this;

    if (number >= 999950000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 999950) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
