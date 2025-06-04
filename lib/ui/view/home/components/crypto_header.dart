import 'package:flutter/material.dart';
import '../../../design_system/app_theme.dart';

class CryptoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int favoritesCount;
  final VoidCallback onFavoritesPressed;
  
  const CryptoAppBar({
    super.key,
    required this.favoritesCount,
    required this.onFavoritesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // Material 3 scroll behavior
      scrolledUnderElevation: 4.0,
      surfaceTintColor: AppTheme.accentColor.withOpacity(0.1),
      backgroundColor: AppTheme.primaryColor, // Use solid color instead of gradient
      foregroundColor: AppTheme.textPrimary,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.currency_bitcoin,
              color: AppTheme.accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Text('BrasilCripto'),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Badge.count(
            count: favoritesCount,
            backgroundColor: Colors.white,
            textColor: AppTheme.cardColor,
            offset: const Offset(2, -2),
            child: IconButton(
              onPressed: onFavoritesPressed,
              icon: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 24,
              ),
              tooltip: 'Favoritos',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 