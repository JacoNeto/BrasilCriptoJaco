import 'package:flutter/material.dart';
import '../../../design_system/app_theme.dart';
import '../../../design_system/widgets/crypto_chart.dart';
import 'detail_stat_widget.dart';

class CryptoDetailsModal extends StatelessWidget {
  final Map<String, dynamic> crypto;

  const CryptoDetailsModal({
    super.key,
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Título
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.currency_bitcoin,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto['name'],
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    crypto['symbol'].toString().toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${crypto['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '${crypto['change'] >= 0 ? '+' : ''}${crypto['change'].toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: crypto['change'] >= 0 
                          ? AppTheme.profitColor 
                          : AppTheme.lossColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Gráfico
          Text(
            'Desempenho (7 dias)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          CryptoChart(
            data: crypto['chart'].cast<double>(),
            isPositive: crypto['change'] >= 0,
          ),
          
          const SizedBox(height: 24),
          
          // Informações adicionais
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DetailStatWidget(label: 'Volume 24h', value: crypto['volume']),
              const DetailStatWidget(label: 'Cap. Mercado', value: '2.1T'),
              const DetailStatWidget(label: 'Fornecimento', value: '19.5M'),
            ],
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context, Map<String, dynamic> crypto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => CryptoDetailsModal(crypto: crypto),
    );
  }
} 