import 'package:flutter/material.dart';

class SliverSectionHeader extends StatelessWidget {
  final String title;
  const SliverSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
