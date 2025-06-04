import 'package:brasil_cripto/core/intercepts/api_response.dart';
import 'package:brasil_cripto/core/intercepts/failure.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
  bool _interceptorsSetup = false;

  static ApiClient? _instance;

  static getInstance() {
    _instance ??= ApiClient();
    return _instance!;
  }

  String get baseUrl => 'https://api.coingecko.com/api/v3';
  String get apiKey => const String.fromEnvironment('COINGECKO_API_KEY');

  Future<void> _setupInterceptors() async {
    if (_interceptorsSetup) return; // Only setup once
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Set the base URL for CoinGecko API
          options.baseUrl = baseUrl;
          
          // Set headers for CoinGecko API
          options.headers = {
            "Content-Type": "application/json",
            "Accept": "application/json",
          };

          // Add API key to query parameters for CoinGecko API
          if (apiKey.isNotEmpty) {
            options.queryParameters = {
              ...options.queryParameters,
              'x_cg_demo_api_key': apiKey,
            };
          }

          options.validateStatus = (status) {
            return status! < 600;
          };
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Handle rate limiting or other API-specific responses
          if (response.statusCode == 429) {
            // Rate limit exceeded - could implement retry logic here
            print('Rate limit exceeded for CoinGecko API');
          }
          return handler.next(response);
        },
      ),
    );
    
    _interceptorsSetup = true;
  }

  // DRY: Generic request method for all HTTP methods with error handling
  Future<ApiResponse<Map<String, dynamic>>> _request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _setupInterceptors();

      late Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(path, queryParameters: queryParameters, options: options);
          break;
        case 'POST':
          response = await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
          break;
        case 'PUT':
          response = await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
          break;
        case 'PATCH':
          response = await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
          break;
        case 'DELETE':
          response = await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      final apiResponse = ApiResponse<Map<String, dynamic>>(
        response.statusCode,
        response.statusCode == 500
            ? null
            : (response.data is Map<String, dynamic>)
            ? response.data as Map<String, dynamic>
            : {},
      );

      // Handle status codes and throw appropriate Failures
      if (apiResponse.statusCode == 200) {
        return apiResponse;
      }
      
      throw Failure(apiResponse.data?['message'] ?? 'Erro desconhecido');
      
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(e.toString());
    }
  }

  // Simple, clean HTTP method implementations
  Future<ApiResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request('GET', path, queryParameters: queryParameters, options: options);

  Future<ApiResponse<Map<String, dynamic>>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request('POST', path, data: data, queryParameters: queryParameters, options: options);

  Future<ApiResponse<Map<String, dynamic>>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request('PUT', path, data: data, queryParameters: queryParameters, options: options);

  Future<ApiResponse<Map<String, dynamic>>> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request('PATCH', path, data: data, queryParameters: queryParameters, options: options);

  Future<ApiResponse<Map<String, dynamic>>> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _request('DELETE', path, data: data, queryParameters: queryParameters, options: options);
}
