import 'package:brasil_cripto/core/intercepts/utils/failure.dart';
import 'package:brasil_cripto/data/services/hive_service.dart';
import 'package:brasil_cripto/domain/models/coin/coin_model.dart';
import 'package:brasil_cripto/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';

class LocalFavoritesRepository implements FavoritesRepository {
  final HiveService hiveService;
  
  // Stream controller para notificar mudanças
  final StreamController<List<CoinModel>> _favoritesController = 
      StreamController<List<CoinModel>>.broadcast();

  LocalFavoritesRepository({required this.hiveService});

  @override
  Stream<List<CoinModel>> get favoritesStream => _favoritesController.stream;

  // DRY: Wrapper comum para tratamento de erros
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

  // Método auxiliar para emitir a lista atualizada de favoritos
  Future<void> _emitUpdatedFavorites() async {
    try {
      final favorites = hiveService.getAllCoins();
      _favoritesController.add(favorites);
    } catch (e) {
      // Em caso de erro, emitir lista vazia
      _favoritesController.add([]);
    }
  }

  @override
  Future<Either<Failure, List<CoinModel>>> getFavorites() async {
    return _handleOperation(
      () async {
        final favorites = hiveService.getAllCoins();
        // Emitir no stream também (para casos onde o stream ainda não foi inicializado)
        _favoritesController.add(favorites);
        return favorites;
      },
      'Falha ao buscar favoritos',
    );
  }

  @override
  Future<Either<Failure, void>> addFavorite(CoinModel coin) async {
    final result = await _handleOperation(
      () async {
        if (hiveService.coinExists(coin.id)) {
          throw Exception('Moeda já está nos favoritos');
        }
        await hiveService.storeCoin(coin);
      },
      'Falha ao adicionar favorito',
    );
    
    // Emitir lista atualizada independentemente do resultado
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
          throw Exception('Moeda não encontrada nos favoritos');
        }
      },
      'Falha ao remover favorito',
    );
    
    // Emitir lista atualizada independentemente do resultado
    if (result.isRight()) {
      await _emitUpdatedFavorites();
    }
    
    return result;
  }

  // Método auxiliar para verificar se uma moeda já está favoritada
  Future<bool> isFavorite(CoinModel coin) async {
    try {
      return hiveService.coinExists(coin.id);
    } catch (e) {
      return false;
    }
  }

  // Método auxiliar para limpar todos os favoritos (útil para testes ou preferência do usuário)
  @override
  Future<Either<Failure, void>> clearAllFavorites() async {
    final result = await _handleOperation(
      () async => await hiveService.clearAllCoins(),
      'Falha ao limpar favoritos',
    );
    
    // Emitir lista vazia independentemente do resultado
    if (result.isRight()) {
      _favoritesController.add([]);
    }
    
    return result;
  }

  // Dispose do stream controller
  void dispose() {
    _favoritesController.close();
  }
}