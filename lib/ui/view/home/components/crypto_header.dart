import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import 'market_stat_widget.dart';

class CryptoHeader extends StatelessWidget {
  final Widget? favoritesButton;
  
  const CryptoHeader({
    super.key,
    this.favoritesButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.currency_bitcoin,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'BrasilCripto',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                // Botão de favoritos
                if (favoritesButton != null) favoritesButton!,
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Mercado de Criptomoedas',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                MarketStatWidget(label: 'Cap. Mercado', value: 'R\$ 8.2T'),
                SizedBox(width: 20),
                MarketStatWidget(label: 'Volume 24h', value: 'R\$ 89.5B'),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 