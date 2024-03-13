import 'package:http/http.dart' as http;

class HttpClient {

  HttpClient({required this.baseUrl});

  final String baseUrl;

  Future<void> generateSectionSnapshot(String sectionId) async {
    await http.post(
      Uri.parse('$baseUrl/board/sections/$sectionId'),
    );
  }
}
