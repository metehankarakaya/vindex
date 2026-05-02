import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/backup_provider.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/utils/vindex_snackbar.dart';
import '../../recurrings/providers/recurring_transaction_provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../widgets/show_export_options.dart';

class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.dataManagement.tr())),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _SectionTitle(title: AppStrings.backup.tr()),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(AppStrings.exportData.tr()),
            subtitle: Text(AppStrings.exportSubtitle.tr()),
            onTap: () => ExportOptionsSheet.show(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: Text(AppStrings.importData.tr()),
            subtitle: Text(AppStrings.importSubtitle.tr()),
            onTap: () => _confirmAction(
              context,
              AppStrings.importWarning.tr(),
                  () async {
                final result = await ref.read(backupServiceProvider).importBackup();
                if (context.mounted) {
                  final message = switch (result) {
                    ImportResult.success => AppStrings.importSuccess.tr(),
                    ImportResult.invalidFile => AppStrings.importInvalidFile.tr(),
                    ImportResult.cancelled => null,
                    ImportResult.error => AppStrings.importError.tr(),
                  };
                  if (message != null) {
                    VindexSnackBar.showSnackBar(
                      context,
                      message,
                      isSuccess: result == ImportResult.success
                    );
                  }
                }
              },
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          _SectionTitle(title: AppStrings.reset.tr(), isDanger: true),
          ListTile(
            leading: Icon(Icons.history, color: colorScheme.error),
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
            leading: Icon(Icons.event_repeat, color: colorScheme.error),
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
            leading: Icon(Icons.factory_outlined, color: colorScheme.error),
            title: Text(
              AppStrings.factoryReset.tr(),
              style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.bold),
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
    final colorScheme = Theme.of(context).colorScheme;

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colorScheme.error),
            const SizedBox(width: 12),
            Text(AppStrings.areYouSure.tr()),
          ],
        ),
        content: Text("$message\n\n${AppStrings.cannotBeUndone.tr()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel.tr(), style: TextStyle(color: colorScheme.outline)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
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
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: isDanger
            ? colorScheme.error.withValues(alpha: 0.8)
            : colorScheme.primary.withValues(alpha: 0.7),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
