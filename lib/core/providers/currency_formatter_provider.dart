import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'currency_provider.dart';

final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  final currency = ref.watch(currencyProvider);
  return NumberFormat.currency(locale: 'tr_TR', symbol: currency.symbol);
});
