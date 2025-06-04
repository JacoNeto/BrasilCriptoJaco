import 'package:brasil_cripto/domain/repositories/crypto_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/intercepts/utils/safe_api_call.dart';
import '../../core/intercepts/utils/failure.dart';
import '../../domain/models/coin/coin_model.dart';
import '../../domain/models/coin_data/coin_data_model.dart';
import '../services/api_service.dart';

class RemoteCryptoRepository implements CryptoRepository {
  final ApiService apiService;

  RemoteCryptoRepository({required this.apiService});

  @override
  Future<Either<Failure, List<CoinModel>>> search(String query) async {
    return safeApiCall(() async {
      final response = await apiService.search(query);
      return response.data?["coins"]
              ?.map<CoinModel>((e) => CoinModel.fromJson(e))
              .toList() ??
          <CoinModel>[];
    });
  }

  @override
  Future<Either<Failure, CoinDataModel>> coinDataById(String id) async {
    return safeApiCall(() async {
      final response = await apiService.coinDataById(id);
      return CoinDataModel.fromJson(response.data ?? {});
    });
  }
}
