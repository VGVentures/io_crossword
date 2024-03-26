import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';

const _miniMapPath = 'board/mini-map.png';

Future<Response> onRequest(RequestContext request) async {
  if (request.request.method == HttpMethod.get) {
    return _onGet(request);
  } else if (request.request.method == HttpMethod.post) {
    return _onPost(request);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext request) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final boardrenderer = request.read<BoardRenderer>();

  final sections = await crosswordRepository.listAllSections();

  final words = sections.expand((section) => section.words);

  final image = await boardrenderer.renderBoardWireframe(
    words.toList(),
    cellSize: 4,
  );

  final firebaseCloudStorage = request.read<FirebaseCloudStorage>();
  final imageUrl = await firebaseCloudStorage.uploadFile(
    image,
    _miniMapPath,
  );

  return Response.json(
    body: {'url': imageUrl},
  );
}

Future<Response> _onGet(RequestContext request) async {
  final firebaseCloudStorage = request.read<FirebaseCloudStorage>();

  return Response.movedPermanently(
    location: firebaseCloudStorage.fileUrl(
      _miniMapPath,
    ),
  );
}
