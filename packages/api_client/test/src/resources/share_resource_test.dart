import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group('ShareResource', () {
    late ApiClient apiClient;
    late ShareResource resource;

    setUp(() {
      apiClient = _MockApiClient();

      when(() => apiClient.shareWordUrl(any(), any())).thenReturn('wordUrl');
      when(() => apiClient.shareScoreUrl(any())).thenReturn('scoreUrl');

      resource = ShareResource(
        apiClient: apiClient,
      );
    });

    test('can be instantiated', () {
      expect(
        resource,
        isNotNull,
      );
    });

    test('facebookShareScoreUrl returns the correct url', () {
      expect(
        resource.facebookShareScoreUrl('id'),
        contains('scoreUrl'),
      );
    });

    test('facebookShareScoreUrl returns the correct url', () {
      expect(
        resource.facebookShareWordUrl('sectionId', 'wordId'),
        contains('wordUrl'),
      );
    });

    test('instagramShareScoreUrl returns the correct url', () {
      expect(
        resource.instagramShareScoreUrl('id'),
        contains('scoreUrl'),
      );
    });

    test('instagramShareWordUrl returns the correct url', () {
      expect(
        resource.instagramShareWordUrl('sectionId', 'wordId'),
        contains('wordUrl'),
      );
    });

    test('twitterShareScoreUrl returns the correct url', () {
      expect(
        resource.twitterShareScoreUrl('id'),
        contains('scoreUrl'),
      );
    });

    test('twitterShareWordUrl returns the correct url', () {
      expect(
        resource.twitterShareWordUrl('sectionId', 'wordId'),
        contains('wordUrl'),
      );
    });

    test('linkedinShareScoreUrl returns the correct url', () {
      expect(
        resource.linkedinShareScoreUrl('id'),
        contains('scoreUrl'),
      );
    });

    test('linkedinShareWordUrl returns the correct url', () {
      expect(
        resource.linkedinShareWordUrl('sectionId', 'wordId'),
        contains('wordUrl'),
      );
    });

    test('facebookShareBaseUrl returns the correct url', () {
      when(() => apiClient.baseUrl).thenReturn('https://baseurl');

      expect(
        resource.facebookShareBaseUrl(),
        equals('https://www.facebook.com/sharer.php?u=https://baseurl'),
      );
    });

    test('twitterShareBaseUrl returns the correct url', () {
      when(() => apiClient.baseUrl).thenReturn('https://baseurl');

      expect(
        resource.twitterShareBaseUrl(),
        equals(
          'https://twitter.com/intent/tweet?text=Check%20out'
          '%20IOCrossword%20%23GoogleIO!%0ahttps://baseurl',
        ),
      );
    });

    test('linkedinShareBaseUrl returns the correct url', () {
      when(() => apiClient.baseUrl).thenReturn('https://baseurl');

      expect(
        resource.linkedinShareBaseUrl(),
        equals(
          'https://www.linkedin.com/sharing/share-offsite/'
          '?url=https://baseurl',
        ),
      );
    });
  });
}
