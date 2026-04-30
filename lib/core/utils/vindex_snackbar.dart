import 'package:flutter/material.dart';

class VindexSnackBar {
  static void showSnackBar(BuildContext context, String message, {bool isSuccess = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: isSuccess ? Colors.white : colorScheme.onSurfaceVariant,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess
          ? Colors.greenAccent[700]
          : theme.colorScheme.surfaceContainerHighest,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
