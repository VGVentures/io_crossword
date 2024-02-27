import 'dart:io';

/// {@template json_content_type}
/// Extension on [Map<String, String>] to add content-type value
/// {@endtemplate}
extension JsonContentType on Map<String, String> {
  /// Adds content-type to map
  void addContentTypeJson() {
    addAll({HttpHeaders.contentTypeHeader: ContentType.json.value});
  }
}
