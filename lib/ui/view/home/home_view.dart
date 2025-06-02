import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/home_view_model.dart';
import '../../core/app_theme.dart';
import 'components/crypto_header.dart';
import 'components/crypto_search_field.dart';
import 'components/crypto_list.dart';
import 'components/crypto_details_modal.dart';
import '../../../domain/models/coin/coin_model.dart';
import '../favorites/favorites_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  void _showCryptoDetails(CoinModel crypto) {
    // Convert CoinModel to Map for the modal (temporary solution)
    final cryptoMap = {
      'name': crypto.name ?? 'Unknown',
      'symbol': crypto.symbol ?? crypto.apiSymbol ?? 'N/A',
      'price': 0.0,
      'change': 0.0,
      'volume': 'N/A',
      'chart': <double>[],
    };
    CryptoDetailsModal.show(context, cryptoMap);
  }

  void _onFavoriteChanged(CoinModel crypto, bool newFavoriteStatus) {
    final viewModel = context.read<HomeViewModel>();
    viewModel.toggleFavorite(crypto);
  }

  void _navigateToFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FavoritesView(),
      ),
    );
  }

  late final HomeViewModel _viewModel;
  
  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    // Carregar favoritos ao inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header personalizado com botão de favoritos
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                return CryptoHeader(
                  favoritesButton: IconButton(
                    onPressed: _navigateToFavorites,
                    icon: Badge.count(
                      count: viewModel.favorites.length,
                      backgroundColor: AppTheme.accentColor,
                      offset: const Offset(10, -10),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    tooltip: 'Favoritos',
                  ),
                );
              },
            ),

            // Campo de busca
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                return CryptoSearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    viewModel.searchWithDebounce(value);
                  },
                  searchQuery: viewModel.searchQuery,
                );
              },
            ),

            // Lista de criptomoedas
            Expanded(
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, _) {
                  return CryptoList(
                    searchResult: viewModel.searchResult,
                    onCryptoTap: _showCryptoDetails,
                    onFavoriteChanged: _onFavoriteChanged,
                    isFavorite: viewModel.isFavorite,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
