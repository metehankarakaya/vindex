import 'package:drift/drift.dart' hide Column;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/utils/currency_input_formatter.dart';
import 'package:vindex/core/widgets/category_selector.dart';
import 'package:vindex/core/widgets/save_transaction_button.dart';
import 'package:vindex/core/widgets/transaction_type_selector.dart';
import 'package:vindex/features/transactions/providers/transaction_provider.dart';
import '../../../core/models/transactions_table.dart';
import '../../../database/app_database.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  static final _formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  bool get _isFormValid {
    final amount = _formatter.tryParse(_amountController.text.trim());
    return _selectedCategory != null &&
      amount != null &&
      amount > 0;
  }

  void _saveTransaction() async {
    String uuid = Uuid().v4();
    final amount = _formatter.tryParse(_amountController.text.trim());
    final int amountCent = (amount! * 100).round();
    final entry = TransactionsCompanion(
      id: Value(uuid),
      title: Value(_titleController.text.trim()),
      amountCents: Value(amountCent),
      category: Value(_selectedCategory!),
      type: Value(_selectedType),
      createdAt: Value(DateTime.now()),
    );
    await ref.read(transactionDaoProvider).insertTransaction(entry);
    if (mounted) Navigator.pop(context);
  }


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              onChanged: (_) => setState(() {}),
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: "₺0,00",
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
              ),
              inputFormatters: [
                CurrencyInputFormatter(_formatter)
              ],
            ),
            const SizedBox(height: 24),
            TransactionTypeSelector(
              selectedType: _selectedType,
              onTypeSelected: (type) => setState(() {_selectedType = type;}),
            ),
            const SizedBox(height: 24),
            CategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) => setState(() => _selectedCategory = category)
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: InputDecoration(
                counterText: "",
                hintText: AppStrings.transactionSum,
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.edit_note),
              ),
            ),
            const SizedBox(height: 24),
            SaveTransactionButton(
              label: AppStrings.saveTransaction,
              onPressed: _isFormValid ? _saveTransaction : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
