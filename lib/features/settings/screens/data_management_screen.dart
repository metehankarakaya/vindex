import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../recurrings/providers/recurring_transaction_provider.dart';
import '../../transactions/providers/transaction_provider.dart';

class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.dataManagement.tr())),
      body: ListView(
        children: [
          _SectionTitle(title: AppStrings.backup.tr()),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(AppStrings.exportData.tr()),
            subtitle: Text(AppStrings.exportSubtitle.tr()),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: Text(AppStrings.importData.tr()),
            subtitle: Text(AppStrings.importSubtitle.tr()),
            onTap: () {},
          ),
          const Divider(),
          _SectionTitle(title: AppStrings.reset.tr(), isDanger: true),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.red),
            title: Text(AppStrings.clearTransactions.tr()),
            onTap: () => _confirmAction(
              context,
              AppStrings.clearTransactionsDesc.tr(),
              () async {
                await ref.read(transactionDaoProvider).deleteAllTransactions();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_repeat, color: Colors.red),
            title: Text(AppStrings.clearRecurring.tr()),
            onTap: () => _confirmAction(
              context,
              AppStrings.clearRecurringDesc.tr(),
              () async {
                await ref.read(recurringTransactionDaoProvider).deleteAllRecurringTransactions();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.factory_outlined, color: Colors.red),
            title: Text(
              AppStrings.factoryReset.tr(),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _confirmAction(
              context,
              AppStrings.factoryResetDesc.tr(),
              () async {
                await ref.read(transactionDaoProvider).deleteAllTransactions();
                await ref.read(recurringTransactionDaoProvider).deleteAllRecurringTransactions();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAction(
      BuildContext context,
      String message,
      Future<void> Function() onConfirm) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.areYouSure.tr()),
        content: Text("$message\n\n${AppStrings.cannotBeUndone.tr()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel.tr()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.yesDelete.tr()),
          ),
        ],
      ),
    );

    if (result == true) {
      await onConfirm();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.actionCompleted.tr()),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDanger;

  const _SectionTitle({required this.title, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDanger
            ? Colors.red.withValues(alpha: 0.8)
            : colorScheme.primary.withValues(alpha: 0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
