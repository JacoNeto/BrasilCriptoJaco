import 'package:brasil_cripto/domain/repositories/crypto_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/intercepts/failure.dart';
import '../../domain/models/coin/coin_model.dart';
import '../../domain/models/coin_data/coin_data_model.dart';
import '../services/api_service.dart';

class RemoteCryptoRepository implements CryptoRepository {
  final ApiService apiService;

  RemoteCryptoRepository({required this.apiService});

  // DRY: Generic method to handle API calls with consistent error handling
  Future<Either<Failure, T>> _handleApiCall<T>(
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

  @override
  Future<Either<Failure, List<CoinModel>>> search(String query) async {
    return _handleApiCall(() async {
      final response = await apiService.search(query);
      return response.data?["coins"]?.map<CoinModel>((e) => CoinModel.fromJson(e)).toList() ?? <CoinModel>[];
    });
  }

  @override
  Future<Either<Failure, CoinDataModel>> coinDataById(String id) async {
    return _handleApiCall(() async {
      final response = await apiService.coinDataById(id);
      return CoinDataModel.fromJson(response.data ?? {});
    });
  }
}