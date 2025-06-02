import 'package:brasil_cripto/domain/repositories/crypto_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/intercepts/failure.dart';
import '../../../domain/models/coin/coin_model.dart';
import '../../services/api_service.dart';

class RemoteCryptoRepository implements CryptoRepository {
  final ApiService apiService;

  RemoteCryptoRepository({required this.apiService});

  @override
  Future<Either<Failure, List<CoinModel>>> search(String query) async {
    try {
      final response = await apiService.search(query);
      return Right(
        response.data?["coins"]?.map<CoinModel>((e) => CoinModel.fromJson(e)).toList() ??
            <CoinModel>[],
      );
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
