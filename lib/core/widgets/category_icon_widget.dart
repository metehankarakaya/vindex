import 'package:flutter/material.dart';

import '../utils/category_utils.dart';

class CategoryIconWidget extends StatelessWidget {
  final String category;
  const CategoryIconWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final color = colorForCategory(category);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconForCategory(category),
        color: color,
        size: 24,
      ),
    );
  }
}
