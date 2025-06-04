import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/home_view_model.dart';
import 'components/crypto_header.dart';
import 'components/crypto_search_field.dart';
import 'components/crypto_sliver_list.dart';
import '../../../domain/models/coin/coin_model.dart';
import '../favorites/favorites_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

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
      appBar: CryptoAppBar(
        favoritesCount: context.watch<HomeViewModel>().favorites.length,
        onFavoritesPressed: _navigateToFavorites,
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return SafeArea(
            top: false, // AppBar handles top safe area
            child: CustomScrollView(
              slivers: [
                // Search field as sliver
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16),
                    child: CryptoSearchField(
                      controller: _searchController,
                      onChanged: (value) {
                        viewModel.searchWithDebounce(value);
                      },
                      searchQuery: viewModel.searchQuery,
                    ),
                  ),
                ),

                // Crypto list (already a sliver)
                CryptoSliverList(
                  viewModel: viewModel,
                  onFavoriteChanged: _onFavoriteChanged,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
