import 'package:api_client/api_client.dart';

/// {@template crossword_resource}
///  An api resource for the public sharing API.
/// {@endtemplate}
class ShareResource {
  /// {@macro crossword_resource}
  ShareResource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final _tweetScoreContent = 'Check out my score at IOCrossword #GoogleIO!';

  final _tweetContent = 'Check out IOCrossword #GoogleIO!';

  String _twitterShareUrl(String text) =>
      'https://twitter.com/intent/tweet?text=$text';

  String _facebookShareUrl(String shareUrl) =>
      'https://www.facebook.com/sharer.php?u=$shareUrl';

  String _instagramShareUrl(String shareUrl) =>
      'https://www.instagram.com/?url=$shareUrl';

  String _linkedinShareUrl(String shareUrl) =>
      'https://www.linkedin.com/sharing/share-offsite/?url=$shareUrl';

  // TODO(any): Consider relying on built-in Uri encoding.
  // https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6444093330
  String _encode(List<String> content) =>
      content.join('%0a').replaceAll(' ', '%20').replaceAll('#', '%23');

  /// Returns the url to share a facebook post for the score.
  String facebookShareScoreUrl(String userId) {
    final shareUrl = _apiClient.shareScoreUrl(userId);
    return _facebookShareUrl(shareUrl);
  }

  /// Returns the url to share a twitter post for the score.
  String twitterShareScoreUrl(String userId) {
    final shareUrl = _apiClient.shareScoreUrl(userId);
    final content = [
      _tweetScoreContent,
      shareUrl,
    ];
    return _twitterShareUrl(_encode(content));
  }

  /// Returns the url to share a instagram post for the score.
  String instagramShareScoreUrl(String userId) {
    final shareUrl = _apiClient.shareScoreUrl(userId);
    return _instagramShareUrl(shareUrl);
  }

  /// Returns the url to share a linkedin post for the score.
  String linkedinShareScoreUrl(String userId) {
    final shareUrl = _apiClient.shareScoreUrl(userId);
    return _linkedinShareUrl(shareUrl);
  }

  /// Returns the url to share a facebook post for a word.
  String facebookShareWordUrl(String sectionId, String wordId) {
    final shareUrl = _apiClient.shareWordUrl(sectionId, wordId);
    return _facebookShareUrl(shareUrl);
  }

  /// Returns the url to share a twitter post for a word.
  String twitterShareWordUrl(String sectionId, String wordId) {
    final shareUrl = _apiClient.shareWordUrl(sectionId, wordId);
    final content = [
      _tweetContent,
      shareUrl,
    ];
    return _twitterShareUrl(_encode(content));
  }

  /// Returns the url to share a instagram post for a word.
  String instagramShareWordUrl(String sectionId, String wordId) {
    final shareUrl = _apiClient.shareWordUrl(sectionId, wordId);
    return _instagramShareUrl(shareUrl);
  }

  /// Returns the url to share a linkedin post for a word.
  String linkedinShareWordUrl(String sectionId, String wordId) {
    final shareUrl = _apiClient.shareWordUrl(sectionId, wordId);
    return _linkedinShareUrl(shareUrl);
  }

  /// Returns the url to share a facebook post.
  String facebookShareBaseUrl() {
    return _facebookShareUrl(_apiClient.baseUrl);
  }

  /// Returns the url to share a twitter post.
  String twitterShareBaseUrl() {
    final shareUrl = _apiClient.baseUrl;
    final content = [
      _tweetContent,
      shareUrl,
    ];
    return _twitterShareUrl(_encode(content));
  }

  /// Returns the url to share a linkedin post.
  String linkedinShareBaseUrl() {
    final shareUrl = _apiClient.baseUrl;
    return _linkedinShareUrl(shareUrl);
  }
}
