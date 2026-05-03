import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class SaveTransactionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SaveTransactionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.12),
          foregroundColor: isEnabled
            ? colorScheme.onPrimary
            : colorScheme.onSurface.withValues(alpha: 0.38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        child: isLoading
          ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.onPrimary.withValues(alpha: 0.7),
            semanticsLabel: AppStrings.loading.tr(),
          ),
        )
          : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ... [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isEnabled
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withValues(alpha: 0.38),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
