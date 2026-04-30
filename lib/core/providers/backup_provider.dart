import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/services/backup_service.dart';
import 'package:vindex/features/recurrings/providers/recurring_transaction_provider.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    ref.watch(transactionDaoProvider),
    ref.watch(recurringTransactionDaoProvider),
  );
});
