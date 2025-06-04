import '../../core/intercepts/api_client.dart';
import '../../core/intercepts/api_response.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();

  Future<ApiResponse<Map<String, dynamic>>> search(String query) {
    return apiClient.get('/search', queryParameters: {'query': query});
  }

  Future<ApiResponse<Map<String, dynamic>>> coinDataById(String id) {
    return apiClient.get(
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
