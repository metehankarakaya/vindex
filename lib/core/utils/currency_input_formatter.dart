import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat formatter;

  CurrencyInputFormatter(this.formatter);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.length > 9) return oldValue;

    double value = double.parse(cleanText) / 100;
    String formatted = formatter.format(value);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
