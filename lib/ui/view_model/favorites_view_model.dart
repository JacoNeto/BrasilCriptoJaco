import 'package:flutter/material.dart';
import 'dart:async';

import '../../domain/repositories/favorites_repository.dart';
import '../../domain/models/coin/coin_model.dart';
import '../../core/utils/delayed_result.dart';

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository favoritesRepository;

  FavoritesViewModel({required this.favoritesRepository}) {
    _initializeFavoritesListener();
  }

  // Estado dos favoritos
  DelayedResult<List<CoinModel>> _favoritesResult = const DelayedResult.idle();
  
  // Stream subscription para ouvir mudanças nos favoritos
  StreamSubscription<List<CoinModel>>? _favoritesSubscription;

  // Getters
  DelayedResult<List<CoinModel>> get favoritesResult => _favoritesResult;
  List<CoinModel> get favorites => _favoritesResult.value ?? [];
  bool get isLoading => _favoritesResult.isInProgress;
  bool get hasError => _favoritesResult.isError;
  bool get hasFavorites => _favoritesResult.isSuccessful && favorites.isNotEmpty;
  String? get errorMessage => _favoritesResult.error?.toString();
  int get favoritesCount => favorites.length;

  // Inicializar listener do stream de favoritos
  void _initializeFavoritesListener() {
    _favoritesSubscription = favoritesRepository.favoritesStream.listen(
      (favoritesList) {
        _favoritesResult = DelayedResult.fromValue(favoritesList);
        debugPrint('FavoritesViewModel sincronizado via stream: ${favoritesList.length} moedas');
        notifyListeners();
      },
      onError: (error) {
        _favoritesResult = DelayedResult.fromError(Exception(error.toString()));
        debugPrint('Erro no stream de favoritos: $error');
        notifyListeners();
      },
    );
  }

  // Carregar favoritos
  Future<void> loadFavorites() async {
    _favoritesResult = const DelayedResult.inProgress();
    notifyListeners();

    final result = await favoritesRepository.getFavorites();
    
    result.fold(
      (failure) {
        _favoritesResult = DelayedResult.fromError(Exception(failure.message));
        debugPrint('Erro ao carregar favoritos: ${failure.message}');
      },
      (favoriteCoins) {
        _favoritesResult = DelayedResult.fromValue(favoriteCoins);
        debugPrint('Favoritos carregados: ${favoriteCoins.length} moedas');
      },
    );
    
    notifyListeners();
  }

  // Remover favorito
  Future<void> removeFavorite(CoinModel coin) async {
    final result = await favoritesRepository.removeFavorite(coin);
    
    result.fold(
      (failure) {
        debugPrint('Erro ao remover favorito: ${failure.message}');
      },
      (_) {
        // O stream listener já vai atualizar o estado automaticamente
        debugPrint('${coin.name} removido dos favoritos');
      },
    );
  }

  // Limpar todos os favoritos
  Future<void> clearAllFavorites() async {
    final result = await favoritesRepository.clearAllFavorites();
    
    result.fold(
      (failure) {
        debugPrint('Erro ao limpar favoritos: ${failure.message}');
      },
      (_) {
        // O stream listener já vai atualizar o estado automaticamente
        debugPrint('Todos os favoritos foram removidos');
      },
    );
  }

  // Recarregar favoritos
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}