import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../transactions/screens/add_transaction_modal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text("DashboardScreen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddTransactionModal.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
