import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import 'cached_coin_image.dart';
import '../../view_model/crypto_details_view_model.dart';
import '../../view/crypto_details/crypto_details_view.dart';
import '../../../domain/repositories/crypto_repository.dart';

class CryptoCard extends StatelessWidget {
  final String? id;
  final String name;
  final String symbol;
  final String iconUrl;
  final int? marketCapRank;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;

  const CryptoCard({
    super.key,
    this.id,
    required this.name,
    required this.symbol,
    required this.iconUrl,
    this.marketCapRank,
    this.isFavorite = false,
    this.onFavoritePressed,
  });

  void _navigateToDetails(BuildContext context) {
    if (id == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => CryptoDetailsViewModel(
            cryptoRepository: GetIt.instance<CryptoRepository>(),
            coinId: id!,
          ),
          child: const CryptoDetailsView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // crypto icon
              CachedCoinImage.circular(
                imageUrl: iconUrl,
                size: 48,
              ),
              const SizedBox(width: 16),

              // crypto information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.accentColor.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            symbol.toUpperCase(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.accentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                        if (marketCapRank != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.textTertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#$marketCapRank',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // favorite button
              IconButton(
                onPressed: onFavoritePressed,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppTheme.textTertiary,
                  size: 24,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              ),

              // clickable indicator (only shows if there is an ID)
              if (id != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
