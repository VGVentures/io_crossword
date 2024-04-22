// coverage:ignore-file
import 'package:google_generative_ai/google_generative_ai.dart';

/// {@template generative_model_wrapper}
/// A wrapper around a generative model to make it testable, since
/// the [GenerativeModel] class is `final`.
/// {@endtemplate}
class GenerativeModelWrapper {
  /// {@macro generative_model_wrapper}
  GenerativeModelWrapper({required this.model});

  /// The generative model to wrap.
  final GenerativeModel model;

  /// Generates text content from the given input [text].
  Future<String?> generateTextContent(String text) async {
    final response = await model.generateContent([Content.text(text)]);
    return response.text;
  }
}
