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

  /// Fetches all sections from the board.
  Future<List<BoardSection>> listAllSections() async {
    final sections = await _dbClient.listAll('boardSections');

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
      'boardSections',
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
      'boardSections',
      DbEntityRecord(
        id: section.id,
        data: section.toJson()..remove('id'),
      ),
    );
  }
}
