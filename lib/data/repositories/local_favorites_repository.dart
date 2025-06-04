import 'package:brasil_cripto/core/intercepts/utils/failure.dart';
import 'package:brasil_cripto/data/services/hive_service.dart';
import 'package:brasil_cripto/domain/models/coin/coin_model.dart';
import 'package:brasil_cripto/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';

class LocalFavoritesRepository implements FavoritesRepository {
  final HiveService hiveService;
  
  // Stream controller to notify changes
  final StreamController<List<CoinModel>> _favoritesController = 
      StreamController<List<CoinModel>>.broadcast();

  LocalFavoritesRepository({required this.hiveService});

  @override
  Stream<List<CoinModel>> get favoritesStream => _favoritesController.stream;

  // DRY: Common wrapper for error handling
  Future<Either<Failure, T>> _handleOperation<T>(
    Future<T> Function() operation,
    String errorContext,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } on HiveServiceException catch (e) {
      return Left(Failure('$errorContext: ${e.message}'));
    } catch (e) {
      return Left(Failure('$errorContext: ${e.toString()}'));
    }
  }

  // Helper method to emit updated favorites list
  Future<void> _emitUpdatedFavorites() async {
    try {
      final favorites = hiveService.getAllCoins();
      _favoritesController.add(favorites);
    } catch (e) {
      // In case of error, emit empty list
      _favoritesController.add([]);
    }
  }

  @override
  Future<Either<Failure, List<CoinModel>>> getFavorites() async {
    return _handleOperation(
      () async {
        final favorites = hiveService.getAllCoins();
        // Also emit to stream (for cases where stream hasn't been initialized yet)
        _favoritesController.add(favorites);
        return favorites;
      },
      'Failed to fetch favorites',
    );
  }

  @override
  Future<Either<Failure, void>> addFavorite(CoinModel coin) async {
    final result = await _handleOperation(
      () async {
        if (hiveService.coinExists(coin.id)) {
          throw Exception('Coin is already in favorites');
        }
        await hiveService.storeCoin(coin);
      },
      'Failed to add favorite',
    );
    
    // Emit updated list regardless of result
    if (result.isRight()) {
      await _emitUpdatedFavorites();
    }
    
    return result;
  }

  @override
  Future<Either<Failure, void>> removeFavorite(CoinModel coin) async {
    final result = await _handleOperation(
      () async {
        final deleted = await hiveService.deleteCoinById(coin.id);
        if (!deleted) {
          throw Exception('Coin not found in favorites');
        }
      },
      'Failed to remove favorite',
    );
    
    // Emit updated list regardless of result
    if (result.isRight()) {
      await _emitUpdatedFavorites();
    }
    
    return result;
  }

  // Helper method to check if a coin is already favorited
  Future<bool> isFavorite(CoinModel coin) async {
    try {
      return hiveService.coinExists(coin.id);
    } catch (e) {
      return false;
    }
  }

  // Helper method to clear all favorites (useful for tests or user preference)
  @override
  Future<Either<Failure, void>> clearAllFavorites() async {
    final result = await _handleOperation(
      () async => await hiveService.clearAllCoins(),
      'Failed to clear favorites',
    );
    
    // Emit empty list regardless of result
    if (result.isRight()) {
      _favoritesController.add([]);
    }
    
    return result;
  }

  // Dispose stream controller
  void dispose() {
    _favoritesController.close();
  }
}