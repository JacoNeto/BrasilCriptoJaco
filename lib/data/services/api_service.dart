import '../../core/intercepts/api_client.dart';
import '../../core/intercepts/api_response.dart';
import '../../core/intercepts/failure.dart';

class ApiService {
  final ApiClient apiClient = ApiClient();

  Future<ApiResponse<Map<String, dynamic>>> search(String query) async {
    final String endpoint = '${apiClient.baseUrl}/search';

    final queryParameters = <String, dynamic>{'query': query};
    try {
      var result = await apiClient.get(endpoint, queryParameters: queryParameters);
      if (result.statusCode == 200) {
        return result;
      } else {
        throw Failure(result.data?['message'] ?? 'Erro desconhecido');
      } 
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
