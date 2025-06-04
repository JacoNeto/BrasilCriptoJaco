import 'package:flutter/material.dart';
import '../app_theme.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final Color? confirmTextColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancelar',
    required this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.confirmTextColor,
  });

  /// Creates a confirmation dialog for destructive actions
  const AppDialog.destructive({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancelar',
    required this.confirmText,
    this.onConfirm,
    this.onCancel,
  }) : isDestructive = true,
       confirmTextColor = null;

  /// Creates a regular confirmation dialog
  const AppDialog.confirmation({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancelar',
    required this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.confirmTextColor,
  }) : isDestructive = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.pop(context),
          child: Text(
            cancelText,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm ?? () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: _getConfirmColor(),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  Color _getConfirmColor() {
    if (confirmTextColor != null) return confirmTextColor!;
    return isDestructive ? Colors.red : AppTheme.accentColor;
  }

  /// Show the dialog and return a Future<bool?> indicating the user's choice
  /// Returns true if confirmed, false if cancelled, null if dismissed
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Cancelar',
    required String confirmText,
    bool isDestructive = false,
    Color? confirmTextColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        isDestructive: isDestructive,
        confirmTextColor: confirmTextColor,
        onCancel: () => Navigator.pop(context, false),
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
  }

  /// Show a destructive confirmation dialog
  static Future<bool?> showDestructive({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = 'Cancelar',
    required String confirmText,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      cancelText: cancelText,
      confirmText: confirmText,
      isDestructive: true,
    );
  }
} 