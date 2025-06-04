import 'package:flutter/material.dart';
import '../../../view_model/crypto_details_view_model.dart';
import '../../../design_system/app_theme.dart';
import '../../../design_system/widgets/cached_coin_image.dart';
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
                              // Coin icon
                              CachedCoinImage.rounded(
                                imageUrl: coinData.image.large,
                                size: 60,
                                borderRadius: 30,
                                backgroundColor: Colors.white,
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

            // Main content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price section
                    PriceSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Chart
                    ChartSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Market statistics
                    MarketStatsSection(viewModel: viewModel),
                    const SizedBox(height: 24),

                    // Description
                    DescriptionSection(viewModel: viewModel),
                    
                    // Extra space at the end
                    const SizedBox(height: 20),
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