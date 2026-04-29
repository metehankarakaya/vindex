import 'package:flutter/material.dart';

class SettingsListItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsListItem({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(leadingIcon),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailing ?? const Icon(Icons.expand_more, size: 20),
          onTap: onTap,
        ),
        if (showDivider)
        Divider(
          height: 1,
          indent: 56,
          endIndent: 16,
          color: theme.colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
