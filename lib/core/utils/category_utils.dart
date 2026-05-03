import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

IconData iconForCategory(String category) {
  switch (category) {
    case AppStrings.market: return Icons.shopping_cart;
    case AppStrings.restaurant: return Icons.restaurant;
    case AppStrings.transport: return Icons.directions_car;
    case AppStrings.subscription: return Icons.subscriptions;
    case AppStrings.bills: return Icons.receipt_long;
    case AppStrings.health: return Icons.local_hospital;
    case AppStrings.entertainment: return Icons.movie;
    case AppStrings.salary: return Icons.attach_money;
    case AppStrings.other: return Icons.category;
    default: return Icons.category;
  }
}

Color colorForCategory(String category) {
  switch (category) {
    case AppStrings.market: return CategoryColors.market;
    case AppStrings.restaurant: return CategoryColors.restaurant;
    case AppStrings.transport: return CategoryColors.transport;
    case AppStrings.subscription: return CategoryColors.subscription;
    case AppStrings.bills: return CategoryColors.bills;
    case AppStrings.health: return CategoryColors.health;
    case AppStrings.entertainment: return CategoryColors.entertainment;
    case AppStrings.salary: return CategoryColors.salary;
    case AppStrings.other: return CategoryColors.other;
    default: return CategoryColors.other;
  }
}
