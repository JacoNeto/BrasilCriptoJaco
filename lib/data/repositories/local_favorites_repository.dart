import 'package:brasil_cripto/core/intercepts/failure.dart';
import 'package:brasil_cripto/data/services/hive_service.dart';
import 'package:brasil_cripto/domain/models/coin/coin_model.dart';
import 'package:brasil_cripto/domain/repositories/favorites_repository.dart';
import 'package:dartz/dartz.dart';

class LocalFavoritesRepository implements FavoritesRepository {
  final HiveService hiveService;

  LocalFavoritesRepository({required this.hiveService});

  // DRY: Wrapper comum para tratamento de erros
  Future<Either<Failure, T>> _handleOperation<T>(
    Future<T> Function() operation,
    String errorContext,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e) {
      return Left(Failure('$errorContext: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CoinModel>>> getFavorites() async {
    return _handleOperation(
      () async => hiveService.getAllCoins(),
      'Falha ao buscar favoritos',
    );
  }

  @override
  Future<Either<Failure, void>> addFavorite(CoinModel coin) async {
    return _handleOperation(
      () async {
        if (hiveService.coinExists(coin.id)) {
          throw Exception('Moeda já está nos favoritos');
        }
        await hiveService.storeCoin(coin);
      },
      'Falha ao adicionar favorito',
    );
  }

  @override
  Future<Either<Failure, void>> removeFavorite(CoinModel coin) async {
    return _handleOperation(
      () async {
        final deleted = await hiveService.deleteCoinById(coin.id);
        if (!deleted) {
          throw Exception('Moeda não encontrada nos favoritos');
        }
      },
      'Falha ao remover favorito',
    );
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
  Future<Either<Failure, void>> clearAllFavorites() async {
    return _handleOperation(
      () async => await hiveService.clearAllCoins(),
      'Falha ao limpar favoritos',
    );
  }
}