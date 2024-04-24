import 'package:collection/collection.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_repository}
/// Repository for interacting with the crossword database in a dart only env.
/// {@endtemplate}
class CrosswordRepository {
  /// {@macro crossword_repository}
  CrosswordRepository({required this.firestore});

  /// The firestore instance.
  final Firestore firestore;

  /// Adds a map of word id: answer to the database.
  Future<void> addAnswers(List<Answer> answers) async {
    const size = 1000;
    final maps = answers.slices(size);

    await Future.wait(maps.map(_addAnswers));
  }

  Future<void> _addAnswers(List<Answer> answers) async {
    final answersCollection = firestore.collection('answers2');
    for (final answer in answers) {
      await answersCollection.doc(answer.id).set(answer.toJson());
    }
  }

  /// Adds a list of sections to the database.
  Future<void> addSections(List<BoardSection> sections) async {
    const size = 200;
    final maps = sections.slices(size);

    await Future.wait(maps.map(_addSections));
  }

  /// Adds a list of sections to the database.
  Future<void> _addSections(List<BoardSection> sections) async {
    for (final section in sections) {
      await firestore.collection('boardChunks2').add(section.toJson());
    }
  }

  /// Deletes all sections from the database.
  Future<void> deleteSections() async {
    var docs = await firestore.collection('boardSections').listDocuments();
    var length = docs.length;
    while (length > 0) {
      for (final doc in docs) {
        await doc.delete();
      }
      docs = await firestore.collection('boardSections').listDocuments();
      length = docs.length;
    }
  }
}
