import 'package:equatable/equatable.dart';

class SpriteInformation extends Equatable {
  const SpriteInformation({
    required this.rows,
    required this.columns,
    required this.width,
    required this.height,
    required this.stepTime,
  });

  final int rows;
  final int columns;
  final double width;
  final double height;
  final double stepTime;

  @override
  List<Object> get props => [
        rows,
        columns,
        width,
        height,
        stepTime,
      ];
}
