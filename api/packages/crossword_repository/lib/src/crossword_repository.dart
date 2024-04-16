import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:db_client/db_client.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_repository}
/// Repository to access the crossword data.
/// {@endtemplate}
class CrosswordRepository {
  /// {@macro crossword_repository}
  const CrosswordRepository({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  static const _sectionsCollection = 'boardChunks';

  /// Fetches all sections from the board.
  Future<List<BoardSection>> listAllSections() async {
    final sections = await _dbClient.listAll(_sectionsCollection);

    return sections.map((sectionDoc) {
      return BoardSection.fromJson({
        'id': sectionDoc.id,
        ...sectionDoc.data,
      });
    }).toList();
  }

  /// Fetches a section by its position.
  Future<BoardSection?> findSectionByPosition(int x, int y) async {
    final result = await _dbClient.find(
      _sectionsCollection,
      {
        'position.x': x,
        'position.y': y,
      },
    );

    if (result.isNotEmpty) {
      return BoardSection.fromJson({
        'id': result.first.id,
        ...result.first.data,
      });
    }

    return null;
  }

  /// Updates a section.
  Future<void> updateSection(BoardSection section) async {
    await _dbClient.update(
      _sectionsCollection,
      DbEntityRecord(
        id: section.id,
        data: section.toJson()..remove('id'),
      ),
    );
  }

  /// Tries solving a word.
  /// Returns true if succeeds and updates the word's solvedTimestamp
  /// attribute.
  Future<bool> answerWord(
    int sectionX,
    int sectionY,
    int wordX,
    int wordY,
    Mascots mascot,
    String answer,
  ) async {
    final section = await findSectionByPosition(sectionX, sectionY);

    if (section == null) {
      return false;
    }

    final word = section.words.firstWhereOrNull(
      (element) => element.position.x == wordX && element.position.y == wordY,
    );

    if (word == null) {
      return false;
    }

    if (answer == word.answer) {
      final solvedWord = word.copyWith(
        solvedTimestamp: clock.now().millisecondsSinceEpoch,
        mascot: mascot,
      );
      final newSection = section.copyWith(
        words: [...section.words..remove(word), solvedWord],
      );
      await updateSection(newSection);
      return true;
    }
    return false;
  }
}
