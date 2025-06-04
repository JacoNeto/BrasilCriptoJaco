import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/favorites_view_model.dart';
import '../../design_system/widgets/crypto_card.dart';
import '../../design_system/widgets/app_dialog.dart';
import '../../design_system/app_theme.dart';
import '../../../domain/models/coin/coin_model.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late final FavoritesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<FavoritesViewModel>();
    // Load favorites on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadFavorites();
    });
  }

  Future<void> _showRemoveDialog(CoinModel coin) async {
    final result = await AppDialog.showDestructive(
      context: context,
      title: 'Remover Favorito',
      content: 'Deseja remover ${coin.name} dos seus favoritos?',
      confirmText: 'Remover',
    );

    if (result == true) {
      _viewModel.removeFavorite(coin);
    }
  }

  Future<void> _showClearAllDialog() async {
    final result = await AppDialog.showDestructive(
      context: context,
      title: 'Limpar Favoritos',
      content: 'Deseja remover todos os favoritos? Esta ação não pode ser desfeita.',
      confirmText: 'Limpar Todos',
    );

    if (result == true) {
      _viewModel.clearAllFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.hasFavorites) {
                return IconButton(
                  onPressed: _showClearAllDialog,
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Limpar todos os favoritos',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<FavoritesViewModel>(
          builder: (context, viewModel, _) {
            // Estado de carregamento
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            // Estado de erro
            if (viewModel.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar favoritos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage ?? 'Erro desconhecido',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewModel.refreshFavorites,
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }
        
            // Estado vazio
            if (!viewModel.hasFavorites) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppTheme.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum favorito ainda',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adicione suas criptomoedas favoritas na tela de busca',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
        
            // Lista de favoritos
            return RefreshIndicator(
              onRefresh: viewModel.refreshFavorites,
              child: ListView.builder(
                itemCount: viewModel.favorites.length,
                padding: const EdgeInsets.only(bottom: 60),
                itemBuilder: (context, index) {
                  final coin = viewModel.favorites[index];
                  return Column(
                    children: [
                      if (index == 0)
                      const SizedBox(height: 10),
                      CryptoCard(
                        id: coin.id,
                        name: coin.name ?? 'Unknown',
                        symbol: coin.symbol ?? coin.apiSymbol ?? 'N/A',
                        iconUrl: coin.thumb ?? coin.large ?? '',
                        marketCapRank: coin.marketCapRank,
                        isFavorite: true, // Sempre true na tela de favoritos
                        onFavoritePressed: () => _showRemoveDialog(coin),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}