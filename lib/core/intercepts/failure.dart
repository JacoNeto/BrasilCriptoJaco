import 'package:brasil_cripto/core/intercepts/api_response.dart';


// TODO: tornar essa classe abstrata
class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => '${runtimeType.toString()} (message: $message)';

  static Failure throwExeption(ApiResponse<Map<String, dynamic>> response) {
    int? statusCode = response.statusCode;
    String message = 'Erro desconhecido';

    if (response.data != null && response.data.runtimeType != String) {
      message = response.data!['message'];
    }

    switch (statusCode) {
      case 400:
        return InvalidParamsExeption(message);
      case 401:
        return AuthExeption(message);
      case 404:
        return RequestNotFoundExeption(message);
      default:
        return Failure(message);
    }
  }
}

class RequestNotFoundExeption extends ApiFailure {
  RequestNotFoundExeption(super.message);
}

class EmptyListExeption extends Failure {
  EmptyListExeption(super.message);
}

class InvalidParamsExeption extends ApiFailure {
  InvalidParamsExeption(super.message);
}

class AuthExeption extends ApiFailure {
  AuthExeption(super.message);
}

class ConnectionError extends Failure {
  ConnectionError(super.message);
}

class TooManyRequestsExeption extends ApiFailure {
  TooManyRequestsExeption(super.message);
}

class ApiFailure extends Failure {
  ApiFailure(super.message);

  static ApiFailure throwExeption(ApiResponse<Map<String, dynamic>> response) {
    int? statusCode = response.statusCode;
    String message = 'Erro desconhecido';

    if (response.data != null && response.data?.runtimeType != String) {
      String? responseMessage = response.data?['message'];
      if (responseMessage != null) {
        message = responseMessage;
      }
    }

    switch (statusCode) {
      case 400:
        return InvalidParamsExeption(message);
      case 401:
        return AuthExeption(message);
      case 404:
        return RequestNotFoundExeption(message);
      case 429:
        return TooManyRequestsExeption('Muitas requisições');
      default:
        //saveCrashlyticsErro(response);
        return ApiFailure(message);
    }
  }
}

class FrontEndFailure extends Failure {
  FrontEndFailure(super.message);
}

/// Utility function to handle API responses consistently across the app.
/// Returns the response if successful, throws appropriate Failure otherwise.
Future<ApiResponse<Map<String, dynamic>>> handleApiResponse(
  Future<ApiResponse<Map<String, dynamic>>> Function() apiCall,
) async {
  try {
    final response = await apiCall();
    if (response.statusCode == 200) {
      return response;
    } else {
      throw ApiFailure.throwExeption(response);
    }
  } catch (e) {
    if (e is Failure) {
      throw Failure(e.message);
    } else {
      throw FrontEndFailure(e.toString());
    }
  }
}
