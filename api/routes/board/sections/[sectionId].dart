import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:firebase_cloud_storage/firebase_cloud_storage.dart';

(int, int)? _parseSectionId(String sectionId) {
  final coordsRaw = sectionId.split(',');
  if (coordsRaw.length != 2) {
    return null;
  }

  final x = int.tryParse(coordsRaw[0]);
  final y = int.tryParse(coordsRaw[1]);

  if (x == null || y == null) {
    return null;
  }

  return (x, y);
}

Future<Response> onRequest(RequestContext request, String sectionId) async {
  if (request.request.method == HttpMethod.get) {
    return _onGet(request, sectionId);
  } else if (request.request.method == HttpMethod.post) {
    return _onPost(request, sectionId);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext request, String sectionId) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final boardrenderer = request.read<BoardRenderer>();

  final pos = _parseSectionId(sectionId);
  final x = pos?.$1;
  final y = pos?.$2;

  if (x == null || y == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final section = await crosswordRepository.findSectionByPosition(x, y);

  if (section == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final image = await boardrenderer.renderSection(section);

  final firebaseCloudStorage = request.read<FirebaseCloudStorage>();
  final imageUrl = await firebaseCloudStorage.uploadFile(
    image,
    'sections/$sectionId.png',
  );

  await crosswordRepository.updateSection(
    section.copyWith(snapshotUrl: imageUrl),
  );

  return Response.json(
    body: {'url': imageUrl},
  );
}

Future<Response> _onGet(RequestContext request, String sectionId) async {
  final crosswordRepository = request.read<CrosswordRepository>();

  final pos = _parseSectionId(sectionId);
  final x = pos?.$1;
  final y = pos?.$2;

  if (x == null || y == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final section = await crosswordRepository.findSectionByPosition(x, y);
  final snapshotUrl = section?.snapshotUrl;

  if (snapshotUrl == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.movedPermanently(
    location: snapshotUrl,
  );
}
