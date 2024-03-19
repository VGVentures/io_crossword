import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';
import 'package:game_domain/game_domain.dart';

Future<Response> onRequest(RequestContext request) async {
  if (request.request.method == HttpMethod.post) {
    return _onPost(request);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext request) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final boardrenderer = request.read<BoardRenderer>();

  late List<(int, int)> positions;

  try {
    final body = await request.request.json() as Map<String, dynamic>;
    final sections = body['sections'] as List;
    positions = sections
        .cast<Map<String, dynamic>>()
        .map((e) => (e['x'] as int, e['y'] as int))
        .toList();
  } catch (e) {
    return Response(
      statusCode: HttpStatus.badRequest,
    );
  }

  final sections = await Future.wait(
    positions.map((e) => crosswordRepository.findSectionByPosition(e.$1, e.$2)),
  );

  final indexes = sections
      .whereType<BoardSection>()
      .map((e) => e.position)
      .toList()
      // Sort by top left corner
      ..sort((a, b) => a.x.compareTo(b.x) == 0
          ? a.y.compareTo(b.y)
          : a.x.compareTo(b.x),);

  final image = await boardrenderer
      .groupSections(sections.whereType<BoardSection>().toList());

  final imageId = indexes.map((e) => e.toString()).join('_');

  final firebaseCloudStorage = request.read<FirebaseCloudStorage>();
  final imageUrl = await firebaseCloudStorage.uploadFile(
    image,
    'group/$imageId.png',
  );

  return Response.json(
    body: {'url': imageUrl},
  );
}

//Future<Response> _onGet(RequestContext request, String sectionId) async {
//  final crosswordRepository = request.read<CrosswordRepository>();
//
//  return Response.movedPermanently(
//    location: snapshotUrl,
//  );
//}
