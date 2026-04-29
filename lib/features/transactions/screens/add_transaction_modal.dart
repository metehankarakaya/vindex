import 'package:flutter/material.dart';
import 'package:vindex/features/transactions/screens/add_transaction_modal_screen.dart';

class AddTransactionModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => AddTransactionModalScreen(),
    );
  }
}
