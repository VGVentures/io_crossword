import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_domain/game_domain.dart';

/// Adds method to QuerySnapshot to convert to BoardSection list
extension BoardSectionFromSnapshot on QuerySnapshot<Map<String, dynamic>> {
  /// Returns data as [BoardSection] list
  List<BoardSection> toBoardSectionList() => docs.map((doc) {
        final dataJson = doc.data();
        dataJson['id'] = doc.id;
        return BoardSection.fromJson(dataJson);
      }).toList();
}
