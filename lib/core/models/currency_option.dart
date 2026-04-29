class CurrencyOption {
  final String code; // "TRY", "USD"
  final String symbol; // "₺", "$"
  final String name; // "Türk Lirası", "US Dollar"

  const CurrencyOption({required this.code, required this.symbol, required this.name});
}

const List<CurrencyOption> supportedCurrencies = [
  CurrencyOption(code: 'TRY', symbol: '₺', name: 'Türk Lirası'),
  CurrencyOption(code: 'USD', symbol: '\$', name: 'US Dollar'),
];
