import 'package:brasil_cripto/core/intercepts/utils/failure.dart';
import 'package:dartz/dartz.dart';

Future<Either<Failure, T>> safeApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return Right(result);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }