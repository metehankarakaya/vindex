import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/models/recurring_transaction_table.dart';
import 'package:vindex/core/models/transactions_table.dart';
import 'package:vindex/database/app_database.dart';
import 'package:vindex/features/recurrings/providers/recurring_transaction_provider.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';

class TestDataFab extends ConsumerWidget {
  const TestDataFab({super.key});

  static const _expenseCategories = [
    AppStrings.market,
    AppStrings.restaurant,
    AppStrings.transport,
    AppStrings.subscription,
    AppStrings.bills,
    AppStrings.health,
    AppStrings.entertainment,
    AppStrings.other,
  ];

  static const _incomeCategories = [AppStrings.salary, AppStrings.other];

  static const Map<String, List<String>> _expenseTitles = {
    AppStrings.market: ['BİM', 'Migros', 'A101', 'Şok'],
    AppStrings.restaurant: ["McDonald's", 'Burger King', 'Yemeksepeti', 'Getir Yemek'],
    AppStrings.transport: ['İETT Kart', 'Uber', 'BiTaksi', 'Akaryakıt'],
    AppStrings.subscription: ['Netflix', 'Spotify', 'YouTube Premium', 'Apple One'],
    AppStrings.bills: ['Elektrik', 'Su', 'Doğalgaz', 'İnternet'],
    AppStrings.health: ['Eczane', 'Muayene', 'Diş Hekimi', 'Optisyen'],
    AppStrings.entertainment: ['Sinema', 'Kitap', 'Steam', 'Konser'],
    AppStrings.other: ['Çeşitli', 'Hediye', 'Temizlik Malz.'],
  };

  static const Map<String, List<String>> _incomeTitles = {
    AppStrings.salary: ['Maaş', 'Prim', 'İkramiye'],
    AppStrings.other: ['Freelance', 'Kira Geliri', 'Satış'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    return FloatingActionButton.small(
      heroTag: 'test_data_fab',
      onPressed: () => _insertTestData(ref),
      tooltip: 'Test verisi ekle',
      child: const Icon(Icons.science_outlined),
    );
  }

  Future<void> _insertTestData(WidgetRef ref) async {
    final txDao = ref.read(transactionDaoProvider);
    final recurringDao = ref.read(recurringTransactionDaoProvider);
    final rng = Random();
    const uuid = Uuid();
    final now = DateTime.now();

    for (int i = 0; i < 20; i++) {
      final isExpense = rng.nextDouble() < 0.7;
      final cats = isExpense ? _expenseCategories : _incomeCategories;
      final category = cats[rng.nextInt(cats.length)];
      final titles = isExpense ? _expenseTitles[category]! : _incomeTitles[category]!;
      final title = titles[rng.nextInt(titles.length)];
      final amountCents = (rng.nextInt(490) + 10) * 100;
      final createdAt = now.subtract(Duration(
        days: rng.nextInt(60),
        hours: rng.nextInt(24),
        minutes: rng.nextInt(60),
      ));

      await txDao.insertTransaction(TransactionsCompanion(
        id: Value(uuid.v4()),
        title: Value(title),
        amountCents: Value(amountCents),
        category: Value(category),
        type: Value(isExpense ? TransactionType.expense : TransactionType.income),
        createdAt: Value(createdAt),
      ));
    }

    final recurringEntries = [
      (AppStrings.salary,       'Maaş',             750000, TransactionType.income,  RecurringFrequency.monthly),
      (AppStrings.subscription, 'Netflix',            14990, TransactionType.expense, RecurringFrequency.monthly),
      (AppStrings.bills,        'Elektrik Faturası',  45000, TransactionType.expense, RecurringFrequency.monthly),
      (AppStrings.transport,    'Akbil Yükleme',      37500, TransactionType.expense, RecurringFrequency.weekly),
      (AppStrings.health,       'Sağlık Sigortası',  120000, TransactionType.expense, RecurringFrequency.yearly),
    ];

    for (final (category, title, amount, type, frequency) in recurringEntries) {
      await recurringDao.insertRecurringTransactions(RecurringTransactionsCompanion(
        id: Value(uuid.v4()),
        title: Value(title),
        amountCents: Value(amount),
        category: Value(category),
        type: Value(type),
        frequency: Value(frequency),
        startDate: Value(now.subtract(const Duration(days: 30))),
      ));
    }
  }
}
