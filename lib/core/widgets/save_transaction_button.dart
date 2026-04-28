import 'package:flutter/material.dart';

class SaveTransactionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const SaveTransactionButton({super.key, required this.label, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
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
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isEnabled ? colorScheme.onPrimary : colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
