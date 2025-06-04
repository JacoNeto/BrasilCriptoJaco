import 'package:flutter/material.dart';
import 'dart:async';

import '../../domain/repositories/crypto_repository.dart';
import '../../domain/models/coin/coin_model.dart';
import '../../core/utils/delayed_result.dart';
import '../../domain/repositories/favorites_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;
  final FavoritesRepository favoritesRepository;

  HomeViewModel({required this.cryptoRepository, required this.favoritesRepository}) {
    _initializeFavoritesListener();
  }

  // Search state management using DelayedResult
  DelayedResult<List<CoinModel>> _searchResult = const DelayedResult.idle();
  String _searchQuery = '';

  // Favorites state management
  DelayedResult<List<CoinModel>> _favoritesResult = const DelayedResult.idle();
  Set<String> _favoriteIds = <String>{};
  bool _favoritesLoaded = false;
  
  // Stream subscription para ouvir mudanças nos favoritos
  StreamSubscription<List<CoinModel>>? _favoritesSubscription;
  
  // Debounce timer para controlar chamadas da API
  Timer? _debounceTimer;

  // Getters
  DelayedResult<List<CoinModel>> get searchResult => _searchResult;
  String get searchQuery => _searchQuery;
  List<CoinModel> get searchResults => _searchResult.value ?? [];
  bool get isLoading => _searchResult.isInProgress;
  bool get hasError => _searchResult.isError;
  bool get hasResults => _searchResult.isSuccessful && searchResults.isNotEmpty;
  String? get errorMessage => _searchResult.error?.toString();

  // Favorites getters
  DelayedResult<List<CoinModel>> get favoritesResult => _favoritesResult;
  List<CoinModel> get favorites => _favoritesResult.value ?? [];
  bool get isFavoritesLoading => _favoritesResult.isInProgress;
  bool get hasFavoritesError => _favoritesResult.isError;

  // Inicializar listener do stream de favoritos
  void _initializeFavoritesListener() {
    _favoritesSubscription = favoritesRepository.favoritesStream.listen(
      (favoritesList) {
        _favoritesResult = DelayedResult.fromValue(favoritesList);
        _favoriteIds = favoritesList.map((coin) => coin.id ?? '').where((id) => id.isNotEmpty).toSet();
        _favoritesLoaded = true;
        debugPrint('Favoritos sincronizados via stream: ${favoritesList.length} moedas');
        notifyListeners();
      },
      onError: (error) {
        _favoritesResult = DelayedResult.fromError(Exception(error.toString()));
        debugPrint('Erro no stream de favoritos: $error');
        notifyListeners();
      },
    );
  }

  // Search functionality
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }

    _searchQuery = query;
    _searchResult = const DelayedResult.inProgress();
    notifyListeners();

    final result = await cryptoRepository.search(query);
    
    result.fold(
      (failure) {
        _searchResult = DelayedResult.fromError(Exception(failure.message));
        debugPrint('Search error: ${failure.message}');
      },
      (coins) {
        _searchResult = DelayedResult.fromValue(coins);
        debugPrint('Search successful: Found ${coins.length} coins');
      },
    );
    
    notifyListeners();
  }

  // Clear search results
  void _clearSearch() {
    _searchResult = const DelayedResult.idle();
    _searchQuery = '';
    notifyListeners();
  }

  // Clear search explicitly (can be called from UI)
  void clearSearch() {
    _clearSearch();
  }

  // Debounced search - useful for search as you type
  void searchWithDebounce(String query) {
    // Cancel any existing timer to prevent multiple API calls
    _debounceTimer?.cancel();
    
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }
    
    // Start new timer - only executes if user stops typing for 800ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      search(query);
    });
  }

  // Favorites functionality
  Future<void> loadFavorites() async {
    if (_favoritesLoaded) return;

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
        _favoriteIds = favoriteCoins.map((coin) => coin.id ?? '').where((id) => id.isNotEmpty).toSet();
        _favoritesLoaded = true;
        debugPrint('Favoritos carregados: ${favoriteCoins.length} moedas');
      },
    );
    
    notifyListeners();
  }

  // Verificar se uma moeda está nos favoritos
  bool isFavorite(CoinModel coin) {
    return _favoriteIds.contains(coin.id);
  }

  // Alternar status de favorito
  Future<void> toggleFavorite(CoinModel coin) async {
    if (coin.id == null) return;

    final isCurrentlyFavorite = isFavorite(coin);
    
    if (isCurrentlyFavorite) {
      await _removeFavorite(coin);
    } else {
      await _addFavorite(coin);
    }
  }

  // Adicionar aos favoritos
  Future<void> _addFavorite(CoinModel coin) async {
    final result = await favoritesRepository.addFavorite(coin);
    
    result.fold(
      (failure) {
        debugPrint('Erro ao adicionar favorito: ${failure.message}');
        // Você pode mostrar um snackbar ou toast aqui
      },
      (_) {
        // O stream listener já vai atualizar o estado automaticamente
        debugPrint('${coin.name} adicionado aos favoritos');
      },
    );
  }

  // Remover dos favoritos
  Future<void> _removeFavorite(CoinModel coin) async {
    final result = await favoritesRepository.removeFavorite(coin);
    
    result.fold(
      (failure) {
        debugPrint('Erro ao remover favorito: ${failure.message}');
        // Você pode mostrar um snackbar ou toast aqui
      },
      (_) {
        // O stream listener já vai atualizar o estado automaticamente
        debugPrint('${coin.name} removido dos favoritos');
      },
    );
  }

  // Recarregar favoritos (útil para atualizar após mudanças)
  Future<void> refreshFavorites() async {
    _favoritesLoaded = false;
    await loadFavorites();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
