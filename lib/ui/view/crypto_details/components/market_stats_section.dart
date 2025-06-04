import 'package:flutter/material.dart';
import '../../../view_model/crypto_details_view_model.dart';
import 'stat_item.dart';

class MarketStatsSection extends StatelessWidget {
  final CryptoDetailsViewModel viewModel;

  const MarketStatsSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas de Mercado',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatItem(
                    title: 'Market Cap',
                    value: viewModel.marketCapUSD,
                  ),
                ),
                Expanded(
                  child: StatItem(
                    title: 'Volume 24h',
                    value: viewModel.volumeUSD,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 