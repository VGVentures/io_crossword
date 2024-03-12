import 'dart:io';

import 'package:board_renderer/board_renderer.dart';
import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext request, String sectionId) async {
  if (request.request.method == HttpMethod.get) {
    return _onGet(request, sectionId);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onGet(RequestContext request, String sectionId) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final boardrenderer = request.read<BoardRenderer>();

  final coordsRaw = sectionId.split(',');
  if (coordsRaw.length != 2) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final x = int.tryParse(coordsRaw[0]);
  final y = int.tryParse(coordsRaw[1]);

  if (x == null || y == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final section = await crosswordRepository.findSectionByPosition(x, y);

  if (section == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  final image = await boardrenderer.renderSection(section);

  return Response.bytes(
    body: image,
    headers: {
      HttpHeaders.contentTypeHeader: 'image/png',
    },
  );
}
