import 'package:flutter/material.dart';
import '../../../view_model/crypto_details_view_model.dart';
import '../../../design_system/app_theme.dart';
import 'price_section.dart';
import 'chart_section.dart';
import 'market_stats_section.dart';
import 'description_section.dart';

class CoinDetailsContent extends StatelessWidget {
  final CryptoDetailsViewModel viewModel;

  const CoinDetailsContent({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final coinData = viewModel.coinData!;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: viewModel.refreshCoinDetails,
        child: CustomScrollView(
          slivers: [
            // App Bar personalizada com gradiente
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.secondaryColor,
                        AppTheme.accentColor,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Ícone da moeda
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    coinData.image.large,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: AppTheme.cardColor,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: const Icon(
                                          Icons.currency_bitcoin,
                                          color: AppTheme.accentColor,
                                          size: 30,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      coinData.name,
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      coinData.symbol.toUpperCase(),
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Conteúdo principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção de preço
                    PriceSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Gráfico
                    ChartSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Estatísticas de mercado
                    MarketStatsSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Descrição
                    DescriptionSection(viewModel: viewModel),
                    
                    // Espaço extra no final
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 