import 'package:flutter/material.dart';
import '../../../design_system/app_theme.dart';
import '../../../design_system/widgets/crypto_card.dart';
import '../../../view_model/home_view_model.dart';
import '../../../../domain/models/coin/coin_model.dart';

class CryptoSliverList extends StatelessWidget {
  final HomeViewModel viewModel;
  final Function(CoinModel, bool) onFavoriteChanged;

  const CryptoSliverList({
    super.key,
    required this.viewModel,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final searchResult = viewModel.searchResult;

    // Loading state
    if (searchResult.isInProgress) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error state
    if (searchResult.isError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
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
                  'Erro ao buscar criptomoedas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  searchResult.error?.toString() ?? 'Erro desconhecido',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Idle state (when app first opens)
    if (searchResult.isIdle) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pesquise por uma criptomoeda',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Digite o nome ou símbolo de uma moeda para começar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Empty results state
    final cryptos = searchResult.value ?? [];
    if (cryptos.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma criptomoeda encontrada',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tente pesquisar por outro nome ou símbolo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Success state with results using proper CryptoCard component
    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16.0,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final crypto = cryptos[index];
              final isCurrentlyFavorite = viewModel.isFavorite(crypto);
              
              return CryptoCard(
                id: crypto.id,
                name: crypto.name ?? 'Unknown',
                symbol: crypto.symbol ?? crypto.apiSymbol ?? 'N/A',
                iconUrl: crypto.thumb ?? crypto.large ?? '',
                marketCapRank: crypto.marketCapRank,
                isFavorite: isCurrentlyFavorite,
                onFavoritePressed: () => onFavoriteChanged(crypto, !isCurrentlyFavorite),
              );
            },
            childCount: cryptos.length,
          ),
        ),
      ),
    );
  }
} 