import 'package:brasil_cripto/core/intercepts/utils/api_response.dart';
import 'package:brasil_cripto/core/intercepts/utils/failure.dart';
import 'package:dio/dio.dart';

class HttpClient {
  final Dio _dio = Dio();
  bool _interceptorsSetup = false;

  static HttpClient? _instance;

  static getInstance() {
    _instance ??= HttpClient();
    return _instance!;
  }

  String get baseUrl => 'https://api.coingecko.com/api/v3';
  String get apiKey => const String.fromEnvironment('COINGECKO_API_KEY');

  Future<void> _setupInterceptors() async {
    if (_interceptorsSetup) return; // Only setup once
    
    // Configure Dio with timeout settings
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      validateStatus: (status) => status! < 600,
    );
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add API key to query parameters for CoinGecko API
          if (apiKey.isNotEmpty) {
            options.queryParameters = {
              ...options.queryParameters,
              'x_cg_demo_api_key': apiKey,
            };
          }
          
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
        onError: (error, handler) {
          // Better error handling for connection issues
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            print('Connection timeout: ${error.message}');
          } else if (error.type == DioExceptionType.connectionError) {
            print('Connection error: ${error.message}');
          }
          return handler.next(error);
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
      
    } on DioException catch (e) {
      String errorMessage;
      
      switch (e.type) {
        case DioExceptionType.connectionError:
          errorMessage = 'Erro de conexão. Verifique sua conexão com a internet e tente novamente.';
          break;
        case DioExceptionType.connectionTimeout:
          errorMessage = 'Tempo limite de conexão esgotado. Tente novamente.';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Tempo limite para receber dados esgotado. Tente novamente.';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Tempo limite para enviar dados esgotado. Tente novamente.';
          break;
        case DioExceptionType.badResponse:
          errorMessage = 'Servidor retornou erro: ${e.response?.statusCode}';
          break;
        case DioExceptionType.cancel:
          errorMessage = 'Requisição cancelada.';
          break;
        default:
          errorMessage = 'Erro de rede: ${e.message}';
      }
      
      print('Dio Error Details: ${e.toString()}');
      throw Failure(errorMessage);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Erro inesperado: ${e.toString()}');
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
