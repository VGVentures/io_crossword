import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:crossword_repository/crossword_repository.dart';
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

  static const _sectionsCollection = 'boardChunks2';
  static const _answersCollection = 'answers2';
  static const _boardInfoCollection = 'boardInfo';

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

  /// Fetches a word answer by its id.
  Future<Answer?> findAnswerById(String id) async {
    final result = await _dbClient.getById(_answersCollection, id);

    if (result != null) {
      return Answer.fromJson({
        'id': result.id,
        ...result.data,
      });
    }

    return null;
  }

  /// Tries solving a word.
  /// Returns true if succeeds and updates the word's solvedTimestamp
  /// attribute.
  Future<bool> answerWord(
    String wordId,
    Mascots mascot,
    String userAnswer,
  ) async {
    final correctAnswer = await findAnswerById(wordId);

    if (correctAnswer == null) {
      throw CrosswordRepositoryException(
        'Answer not found for word with id $wordId',
        StackTrace.current,
      );
    }

    if (userAnswer.toLowerCase() != correctAnswer.answer.toLowerCase()) {
      return false;
    }

    final sectionX = correctAnswer.section.x;
    final sectionY = correctAnswer.section.y;
    final section = await findSectionByPosition(sectionX, sectionY);

    if (section == null) {
      throw CrosswordRepositoryException(
        'Section not found for position ($sectionX, $sectionY)',
        StackTrace.current,
      );
    }

    final word = section.words.firstWhereOrNull((e) => e.id == wordId);

    if (word == null) {
      throw CrosswordRepositoryException(
        'Word with id $wordId not found for section ($sectionX, $sectionY)',
        StackTrace.current,
      );
    }

    if (userAnswer.toLowerCase() == correctAnswer.answer.toLowerCase()) {
      final solvedWord = word.copyWith(
        answer: correctAnswer.answer,
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

  /// Adds one to the solved words count in the crossword.
  Future<void> updateSolvedWordsCount() async {
    final snapshot = await _dbClient.find(
      _boardInfoCollection,
      {
        'type': 'solved_words_count',
      },
    );

    final document = snapshot.first;
    final solvedWordsCount = document.data['value'] as int;
    final newValue = solvedWordsCount + 1;

    await _dbClient.update(
      _boardInfoCollection,
      DbEntityRecord(
        id: document.id,
        data: {
          'value': newValue,
        },
      ),
    );
  }
}
