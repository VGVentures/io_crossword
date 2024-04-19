import 'package:flutter/widgets.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

class Crossword2View extends StatelessWidget {
  const Crossword2View({super.key});

  @override
  Widget build(BuildContext context) {
    const configuration = CrosswordConfiguration(
      bottomLeft: (40, 40),
      chunkSize: 20,
    );

    return CrosswordLayoutScope(
      data: CrosswordLayoutData.fromConfiguration(
        configuration: configuration,
        cellSize: const Size.square(20),
      ),
      child: const CrosswordChunk(
        index: CrosswordConfiguration.topLeft,
      ),
    );
  }
}
