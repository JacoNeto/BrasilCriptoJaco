import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../app_theme.dart';

class CachedCoinImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final IconData fallbackIcon;
  final double? fallbackIconSize;

  const CachedCoinImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.borderRadius = 0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.fallbackIcon = Icons.currency_bitcoin,
    this.fallbackIconSize,
  });

  /// Factory constructor for circular coin images (like in cards)
  factory CachedCoinImage.circular({
    required String imageUrl,
    required double size,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1,
    IconData fallbackIcon = Icons.currency_bitcoin,
  }) {
    return CachedCoinImage(
      imageUrl: imageUrl,
      size: size,
      borderRadius: size / 2,
      backgroundColor: backgroundColor ?? AppTheme.accentColor.withOpacity(0.1),
      borderColor: borderColor ?? AppTheme.accentColor.withOpacity(0.2),
      borderWidth: borderWidth,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.6,
    );
  }

  /// Factory constructor for square/rounded coin images (like in details)
  factory CachedCoinImage.rounded({
    required String imageUrl,
    required double size,
    double borderRadius = 12,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 0,
    IconData fallbackIcon = Icons.currency_bitcoin,
  }) {
    return CachedCoinImage(
      imageUrl: imageUrl,
      size: size,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? Colors.white,
      borderColor: borderColor,
      borderWidth: borderWidth,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderWidth > 0 && borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - borderWidth),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, child, loadingProgress) {
                  return Center(
                    child: SizedBox(
                      width: size * 0.4,
                      height: size * 0.4,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentColor,
                        ),
                        value: loadingProgress.progress,
                      ),
                    ),
                  );
                },
                errorWidget: (context, error, stackTrace) {
                  return _buildFallbackIcon();
                },
              ),
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Icon(
        fallbackIcon,
        color: AppTheme.accentColor,
        size: fallbackIconSize ?? size * 0.6,
      ),
    );
  }
} 