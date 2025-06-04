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

  // favorites result
  DelayedResult<List<CoinModel>> _favoritesResult = const DelayedResult.idle();
  
  // Stream subscription to listen for favorites changes
  StreamSubscription<List<CoinModel>>? _favoritesSubscription;

  // Getters
  DelayedResult<List<CoinModel>> get favoritesResult => _favoritesResult;
  List<CoinModel> get favorites => _favoritesResult.value ?? [];
  bool get isLoading => _favoritesResult.isInProgress;
  bool get hasError => _favoritesResult.isError;
  bool get hasFavorites => _favoritesResult.isSuccessful && favorites.isNotEmpty;
  String? get errorMessage => _favoritesResult.error?.toString();
  int get favoritesCount => favorites.length;

  // initialize favorites listener
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

  // load favorites
  Future<void> loadFavorites() async {
    _favoritesResult = const DelayedResult.inProgress();
    notifyListeners();

    final result = await favoritesRepository.getFavorites();
    
    result.fold(
      (failure) {
        _favoritesResult = DelayedResult.fromError(Exception(failure.message));
        debugPrint('Error loading favorites: ${failure.message}');
      },
      (favorites) {
        _favoritesResult = DelayedResult.fromValue(favorites);
        debugPrint('Favorites loaded: ${favorites.length} coins');
      },
    );
    
    notifyListeners();
  }

  // remove favorite
  Future<void> removeFavorite(CoinModel coin) async {
    final result = await favoritesRepository.removeFavorite(coin);
    
    result.fold(
      (failure) {
        debugPrint('Erro ao remover favorito: ${failure.message}');
      },
      (_) {
        // The stream listener will automatically update the state
        debugPrint('${coin.name} removido dos favoritos');
      },
    );
  }

  // clear all favorites
  Future<void> clearAllFavorites() async {
    final result = await favoritesRepository.clearAllFavorites();
    
    result.fold(
      (failure) {
        debugPrint('Erro ao limpar favoritos: ${failure.message}');
      },
      (_) {
        // The stream listener will automatically update the state
        debugPrint('Todos os favoritos foram removidos');
      },
    );
  }

  // reload favorites
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}