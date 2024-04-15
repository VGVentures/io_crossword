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

  /// Adds a list of word answers to the database.
  Future<void> addAnswers(Map<String, String> answers) async {
    final answersCollection = firestore.collection('answers');
    for (final answer in answers.entries) {
      await answersCollection.doc(answer.key).set({'answer': answer.value});
    }
  }

  /// Adds a list of sections to the database.
  Future<void> addSections(List<BoardSection> sections) async {
    for (final section in sections) {
      await firestore.collection('newBoardSections').add(section.toJson());
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
