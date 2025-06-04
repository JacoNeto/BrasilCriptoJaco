import '../../core/intercepts/failure.dart';
import '../models/coin/coin_model.dart';
import 'package:dartz/dartz.dart';

import '../models/coin_data/coin_data_model.dart';

abstract interface class CryptoRepository {
  Future<Either<Failure, List<CoinModel>>> search(String query);
  Future<Either<Failure, CoinDataModel>> coinDataById(String id);
}