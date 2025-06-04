import '../../core/intercepts/http_client.dart';
import '../../core/intercepts/utils/api_response.dart';

class ApiService {
  final HttpClient httpClient = HttpClient();

  Future<ApiResponse<Map<String, dynamic>>> search(String query) {
    return httpClient.get('/search', queryParameters: {'query': query});
  }

  Future<ApiResponse<Map<String, dynamic>>> coinDataById(String id) {
    return httpClient.get(
      '/coins/$id',
      queryParameters: {
        'localization': false,
        'tickers': false,
        'market_data': true,
        'community_data': false,
        'developer_data': false,
        'sparkline': true,
      },
    );
  }
}
