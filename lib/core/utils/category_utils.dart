import 'package:flutter/material.dart';

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
    case AppStrings.market: return Colors.blue;
    case AppStrings.restaurant: return Colors.orange;
    case AppStrings.transport: return Colors.purple;
    case AppStrings.subscription: return Colors.deepPurple;
    case AppStrings.bills: return Colors.red;
    case AppStrings.health: return Colors.teal;
    case AppStrings.entertainment: return Colors.pink;
    case AppStrings.salary: return Colors.green;
    case AppStrings.other: return Colors.grey;
    default: return Colors.grey;
  }
}
