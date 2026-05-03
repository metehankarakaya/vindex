import 'package:flutter/material.dart';

class SecurityListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool showDivider;

  const SecurityListItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.enabled = true,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          enabled: enabled,
          leading: Icon(icon),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled ? null : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            size: 20,
            color: enabled ? null : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          ),
          onTap: enabled ? onTap : null,
        ),
        if (showDivider)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}
