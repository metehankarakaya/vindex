import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/models/currency_option.dart';
import 'package:vindex/core/providers/shared_preferences_provider.dart';

class CurrencyNotifier extends Notifier<CurrencyOption> {
  static const _key = 'currency_key';

  @override
  CurrencyOption build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedCurrencyName = prefs.getString(_key);
    return supportedCurrencies.firstWhere(
          (c) => c.code == savedCurrencyName,
      orElse: () => supportedCurrencies.first,
    );
  }

  Future<void> setCurrency(CurrencyOption currency) async {
    state = currency;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, currency.code);
  }

}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencyOption>(CurrencyNotifier.new);
