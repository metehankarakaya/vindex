import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateFormatter {
  DateFormatter._();

  static String _localeStr(Locale locale) {
    return (locale.countryCode?.isNotEmpty == true)
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
  }

  /// Formats a transaction date relative to today:
  /// - same day   → "HH:mm"
  /// - < 7 days   → "EEEE HH:mm"
  /// - older      → "d MMM HH:mm"
  static String formatTransactionDate(DateTime date, Locale locale) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    final localeStr = _localeStr(locale);

    if (diff == 0) return DateFormat.Hm(localeStr).format(date);
    if (diff < 7) return DateFormat('EEEE HH:mm', localeStr).format(date);
    return DateFormat('d MMM HH:mm', localeStr).format(date);
  }

  /// Formats a date as "dd MMMM yyyy".
  static String formatFullDate(DateTime date, Locale locale) {
    return DateFormat('dd MMMM yyyy', _localeStr(locale)).format(date);
  }
}
