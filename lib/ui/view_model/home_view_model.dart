import 'package:flutter/material.dart';

import '../../domain/repositories/crypto_repository.dart';
import '../../domain/models/coin/coin_model.dart';
import '../../core/utils/delayed_result.dart';

class HomeViewModel extends ChangeNotifier {
  final CryptoRepository cryptoRepository;

  HomeViewModel({required this.cryptoRepository});

  // Search state management using DelayedResult
  DelayedResult<List<CoinModel>> _searchResult = const DelayedResult.idle();
  String _searchQuery = '';

  // Getters
  DelayedResult<List<CoinModel>> get searchResult => _searchResult;
  String get searchQuery => _searchQuery;
  List<CoinModel> get searchResults => _searchResult.value ?? [];
  bool get isLoading => _searchResult.isInProgress;
  bool get hasError => _searchResult.isError;
  bool get hasResults => _searchResult.isSuccessful && searchResults.isNotEmpty;
  String? get errorMessage => _searchResult.error?.toString();

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
    // Cancel any existing timer if needed
    Future.delayed(const Duration(milliseconds: 500), () {
      search(query);
    });
  }
}
