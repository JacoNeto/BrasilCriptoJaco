import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/home_view_model.dart';
import '../../core/app_theme.dart';
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
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return CustomScrollView(
            slivers: [
              // Header como SliverAppBar com gradiente único
              SliverAppBar(
                expandedHeight: 180,
                floating: false,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: CryptoHeader(
                    favoritesButton: Badge.count(
                      count: viewModel.favorites.length,
                      backgroundColor: Colors.white,
                      textColor: AppTheme.accentColor,
                      offset: const Offset(2, -2),
                      child: IconButton(
                        onPressed: _navigateToFavorites,
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 28,
                        ),
                        tooltip: 'Favoritos',
                      ),
                    ),
                  ),
                ),
              ),

              // Campo de busca
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CryptoSearchField(
                    controller: _searchController,
                    onChanged: (value) {
                      viewModel.searchWithDebounce(value);
                    },
                    searchQuery: viewModel.searchQuery,
                  ),
                ),
              ),

              // Lista de criptomoedas como componente separado
              CryptoSliverList(
                viewModel: viewModel,
                onFavoriteChanged: _onFavoriteChanged,
              ),
            ],
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
