import 'package:brasil_cripto/core/intercepts/api_response.dart';
import 'package:dio/dio.dart';



class ApiClient {
  final Dio _dio = Dio();

  static ApiClient? _instance;

  static getInstance() {
    _instance ??= ApiClient();
    return _instance!;
  }

  final String apiKey = String.fromEnvironment('COINGECKO_API_KEY');
  String get baseUrl => 'https://api.coingecko.com/api/v3';

  Future<void> _setupInterceptors() async {
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
          options.queryParameters = {
            ...options.queryParameters,
            'x_cg_demo_api_key': apiKey,
          };

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
  }

  Future<ApiResponse<Map<String, dynamic>>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _setupInterceptors();
    var response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResponse(
      response.statusCode,
      response.statusCode == 500
          ? null
          : (response.data is Map<String, dynamic>)
          ? response.data
          : {},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _setupInterceptors();
    var response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResponse(
      response.statusCode,
      response.statusCode == 500
          ? null
          : (response.data is Map<String, dynamic>)
          ? response.data
          : {},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _setupInterceptors();

    var response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResponse(
      response.statusCode,
      response.statusCode == 500
          ? null
          : (response.data is Map<String, dynamic>)
          ? response.data
          : {},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> patch(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _setupInterceptors();
    var response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResponse(
      response.statusCode,
      response.statusCode == 500
          ? null
          : (response.data is Map<String, dynamic>)
          ? response.data
          : {},
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _setupInterceptors();
    var response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );

    return ApiResponse(
      response.statusCode,
      response.statusCode == 500
          ? null
          : (response.data is Map<String, dynamic>)
          ? response.data
          : {},
    );
  }
}
