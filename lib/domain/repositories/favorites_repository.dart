import 'package:dartz/dartz.dart';

import '../../core/intercepts/utils/failure.dart';
import '../models/coin/coin_model.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<CoinModel>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(CoinModel coin);
  Future<Either<Failure, void>> removeFavorite(CoinModel coin);
  Future<Either<Failure, void>> clearAllFavorites();
  
  // Stream to notify favorites changes
  Stream<List<CoinModel>> get favoritesStream;
}