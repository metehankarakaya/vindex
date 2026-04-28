import 'package:drift/drift.dart' hide Column;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:vindex/core/widgets/frequency_selector.dart';
import 'package:vindex/database/app_database.dart';
import 'package:vindex/features/recurrings/providers/recurring_transaction_provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/recurring_transaction_table.dart';
import '../../../core/models/transactions_table.dart';
import '../../../core/utils/currency_input_formatter.dart';
import '../../../core/widgets/category_selector.dart';
import '../../../core/widgets/date_picker.dart';
import '../../../core/widgets/save_transaction_button.dart';
import '../../../core/widgets/transaction_type_selector.dart';

class AddRecurringTransactionScreen extends ConsumerStatefulWidget {
  const AddRecurringTransactionScreen({super.key});

  @override
  ConsumerState<AddRecurringTransactionScreen> createState() => _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState extends ConsumerState<AddRecurringTransactionScreen> {
  static final _formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  bool get _isFormValid {
    final amount = _formatter.tryParse(_amountController.text.trim());
    final title = _titleController.text.trim();
    return title.isNotEmpty &&
      _selectedCategory != null &&
      _selectedFrequency != null &&
      _startDate != null &&
      amount != null &&
      amount > 0;
  }

  DateTime? get _minEndDate {
    if (_startDate == null || _selectedFrequency == null) return _startDate;

    return switch (_selectedFrequency!) {
      RecurringFrequency.daily => _startDate!.add(const Duration(days: 1)),
      RecurringFrequency.weekly => _startDate!.add(const Duration(days: 7)),
      RecurringFrequency.monthly => DateTime(_startDate!.year, _startDate!.month + 1, _startDate!.day),
      RecurringFrequency.yearly => DateTime(_startDate!.year + 1, _startDate!.month, _startDate!.day),
    };
  }

  void _saveTransaction() async {
    final amount = _formatter.tryParse(_amountController.text.trim());
    if (amount == null) return;

    final int amountCent = (amount * 100).round();
    final String uuid = const Uuid().v4();

    final entry = RecurringTransactionsCompanion(
      id: Value(uuid),
      title: Value(_titleController.text.trim()),
      amountCents: Value(amountCent),
      category: Value(_selectedCategory!),
      type: Value(_selectedType),
      frequency: Value(_selectedFrequency!),
      startDate: Value(_startDate!),
      endDate: Value(_endDate),
    );
    await ref.read(recurringTransactionDaoProvider).insertRecurringTransactions(entry);
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
  RecurringFrequency? _selectedFrequency;
  DateTime? _startDate;
  DateTime? _endDate;

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
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              maxLength: 50,
              decoration: InputDecoration(
                counterText: "",
                hintText: AppStrings.transactionDescription.tr(),
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
            FrequencySelector(
              selectedFrequency: _selectedFrequency,
              onFrequencySelected: (val) {
                setState(() {
                  _selectedFrequency = val;
                  _endDate = null;
                });
              },
            ),
            const SizedBox(height: 24),
            DatePickerField(
              label: AppStrings.startDate.tr(),
              selectedDate: _startDate,
              firstDate: DateTime.now(),
              hintText: AppStrings.pickStartDate.tr(),
              onDateSelected: (picked) {
                setState(() {
                  _startDate = picked;
                  _endDate = null;
                });
              },
            ),
            const SizedBox(height: 24),
            DatePickerField(
              label: AppStrings.endDateOptional.tr(),
              selectedDate: _endDate,
              firstDate: _minEndDate ?? DateTime.now(),
              hintText: AppStrings.pickEndDate.tr(),
              onDateSelected: (picked) => setState(() => _endDate = picked),
            ),
            const SizedBox(height: 24),
            SaveTransactionButton(
              label: AppStrings.saveTransaction.tr(),
              onPressed: _isFormValid ? _saveTransaction : null,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
