import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/widgets/crypto_card.dart';
import '../../../../domain/models/coin/coin_model.dart';
import '../../../../core/utils/delayed_result.dart';

class CryptoList extends StatelessWidget {
  final DelayedResult<List<CoinModel>> searchResult;
  final Function(CoinModel) onCryptoTap;
  final Function(CoinModel, bool) onFavoriteChanged;
  final bool Function(CoinModel) isFavorite;

  const CryptoList({
    super.key,
    required this.searchResult,
    required this.onCryptoTap,
    required this.onFavoriteChanged,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (searchResult.isInProgress) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
    if (searchResult.isError) {
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
      );
    }

    // Idle state (when app first opens)
    if (searchResult.isIdle) {
      return Center(
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
      );
    }

    // Empty results state
    final cryptos = searchResult.value ?? [];
    if (cryptos.isEmpty) {
      return Center(
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
            ),
          ],
        ),
      );
    }

    // Success state with results
    return ListView.builder(
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        final crypto = cryptos[index];
        final isCurrentlyFavorite = isFavorite(crypto);
        
        return GestureDetector(
          onTap: () => onCryptoTap(crypto),
          child: CryptoCard(
            name: crypto.name ?? 'Unknown',
            symbol: crypto.symbol ?? crypto.apiSymbol ?? 'N/A',
            iconUrl: crypto.thumb ?? crypto.large ?? '',
            marketCapRank: crypto.marketCapRank,
            isFavorite: isCurrentlyFavorite,
            onFavoritePressed: () => onFavoriteChanged(crypto, !isCurrentlyFavorite),
          ),
        );
      },
    );
  }
} 