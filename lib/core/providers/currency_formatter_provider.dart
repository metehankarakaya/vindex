import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'currency_provider.dart';
import 'shared_preferences_provider.dart';

final localeProvider = StateProvider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final saved = prefs.getString('locale');
  if (saved != null) return saved;

  final system = PlatformDispatcher.instance.locale;
  return (system.countryCode?.isNotEmpty == true)
      ? '${system.languageCode}_${system.countryCode}'
      : system.languageCode;
});

final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  final currency = ref.watch(currencyProvider);
  final locale = ref.watch(localeProvider);
  return NumberFormat.currency(locale: locale, symbol: currency.symbol);
});
