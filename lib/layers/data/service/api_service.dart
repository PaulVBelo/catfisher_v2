import 'dart:convert';
import 'package:catfisher/layers/domain/service/i_api_service.dart';
import 'package:http/http.dart' as http;
import '../../domain/entity/cat.dart';

class ApiService implements IApiService {
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static const String apiKey =
      'live_4EgwUmgUHLZyMcaD3UxkyKCscFPyLhctbs8KvEummKdOI3XxWlAipOPyk2FFvfi4';

  @override
  Future<List<Cat>> fetchRandomCats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/images/search?has_breeds=1&limit=5'),
        headers: {'x-api-key': apiKey},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((cat) => Cat.fromJson(cat)).toList();
      } else {
        throw Exception('Failed to load cats');
      }
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
