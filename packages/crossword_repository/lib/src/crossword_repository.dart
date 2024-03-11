import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';

/// {@template crossword_repository}
/// Repository to manage the crossword.
/// {@endtemplate}
class CrosswordRepository {
  /// {@macro crossword_repository}
  CrosswordRepository({
    required this.db,
  }) {
    sectionCollection = db.collection('boardSections');
  }

  /// The [FirebaseFirestore] instance.
  final FirebaseFirestore db;

  /// The [CollectionReference] for the matches.
  late final CollectionReference<Map<String, dynamic>> sectionCollection;

  /// Watches a section of the crossword board
  Stream<BoardSection> watchSection(String id) {
    final ref = sectionCollection.doc(id);
    final docStream = ref.snapshots();
    return docStream.map((snapshot) {
      final id = snapshot.id;
      final data = {...snapshot.data() ?? {}, 'id': id};
      return BoardSection.fromJson(data);
    });
  }

  /// Watches the section having the corresponding position
  Stream<BoardSection?> watchSectionFromPosition(
    int x,
    int y,
  ) {
    final snapshot = sectionCollection
        .where(
          'position.x',
          isEqualTo: x,
        )
        .where(
          'position.y',
          isEqualTo: y,
        )
        .snapshots();
    return snapshot.map(
      (snapshot) {
        final doc = snapshot.docs.firstOrNull;
        if (doc != null) {
          final dataJson = doc.data();
          dataJson['id'] = doc.id;
          return BoardSection.fromJson(dataJson);
        }
        return null;
      },
    );
  }
}
