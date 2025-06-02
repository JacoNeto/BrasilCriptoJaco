import '../../core/intercepts/failure.dart';
import '../models/coin/coin_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class CryptoRepository {
  Future<Either<Failure, List<CoinModel>>> search(String query);
}