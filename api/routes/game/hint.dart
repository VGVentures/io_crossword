import 'dart:io';

import 'package:crossword_repository/crossword_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:hint_repository/hint_repository.dart';
import 'package:jwt_middleware/jwt_middleware.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    return _onPost(context);
  } else if (context.request.method == HttpMethod.get) {
    return _onGet(context);
  } else {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _onPost(RequestContext context) async {
  final crosswordRepository = context.read<CrosswordRepository>();
  final hintRepository = context.read<HintRepository>();
  final user = context.read<AuthenticatedUser>();

  final json = await context.request.json() as Map<String, dynamic>;
  final wordId = json['wordId'] as String?;
  final userQuestion = json['question'] as String?;

  if (wordId == null || userQuestion == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  try {
    final isHintsEnabled = await hintRepository.isHintsEnabled();
    if (!isHintsEnabled) {
      return Response(
        body: 'Hints are disabled',
        statusCode: HttpStatus.forbidden,
      );
    }

    final wordAnswer = await crosswordRepository.findAnswerById(wordId);
    if (wordAnswer == null) {
      return Response(
        body: 'Word not found for id $wordId',
        statusCode: HttpStatus.notFound,
      );
    }

    final previousHints = await hintRepository.getPreviousHints(
      userId: user.id,
      wordId: wordId,
    );
    final maxAllowedHints = await hintRepository.getMaxHints();
    if (previousHints.length >= maxAllowedHints) {
      return Response(
        body: 'Max hints reached for word $wordId',
        statusCode: HttpStatus.forbidden,
      );
    }

    final hint = await hintRepository.generateHint(
      wordAnswer: wordAnswer.answer,
      question: userQuestion,
      previousHints: previousHints,
      userToken: user.token,
    );

    await hintRepository.saveHints(
      userId: user.id,
      wordId: wordId,
      hints: [...previousHints, hint],
    );

    return Response.json(
      body: {
        'hint': hint.toJson(),
        'maxHints': maxAllowedHints,
      },
    );
  } catch (e) {
    return Response(
      body: e.toString(),
      statusCode: HttpStatus.internalServerError,
    );
  }
}

Future<Response> _onGet(RequestContext context) async {
  final hintRepository = context.read<HintRepository>();
  final user = context.read<AuthenticatedUser>();

  final wordId = context.request.uri.queryParameters['wordId'];

  if (wordId == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  try {
    final isHintsEnabled = await hintRepository.isHintsEnabled();
    if (!isHintsEnabled) {
      return Response(
        body: 'Hints are disabled',
        statusCode: HttpStatus.forbidden,
      );
    }

    final hints = await hintRepository.getPreviousHints(
      userId: user.id,
      wordId: wordId,
    );
    final maxAllowedHints = await hintRepository.getMaxHints();

    return Response.json(
      body: {
        'hints': hints.map((hint) => hint.toJson()).toList(),
        'maxHints': maxAllowedHints,
      },
    );
  } catch (e) {
    return Response(
      body: e.toString(),
      statusCode: HttpStatus.internalServerError,
    );
  }
}
