import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext request) async {
  if (request.request.method == HttpMethod.get) {
    return _onGet(request);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onGet(RequestContext request) async {
  final crosswordRepository = request.read<CrosswordRepository>();
  final sections = await crosswordRepository.listAllSections();
  return Response.json(
    body: sections.map((section) => section.toJson()).toList(),
  );
}
