import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/providers/currency_formatter_provider.dart';

class LanguageSelector {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentLocale = context.locale;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36, height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _LanguageOption(
                    title: "Türkçe",
                    flag: "🇹🇷",
                    locale: const Locale("tr"),
                    current: currentLocale,
                  ),
                  _LanguageOption(
                    title: "English",
                    flag: "🇺🇸",
                    locale: const Locale("en", "US"),
                    current: currentLocale,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LanguageOption extends ConsumerWidget {
  final String title;
  final String flag;
  final Locale locale;
  final Locale current;

  const _LanguageOption({
    required this.title,
    required this.flag,
    required this.locale,
    required this.current,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = locale == current;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: isSelected ? colorScheme.primary.withValues(alpha: 0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
            ? BorderSide(color: colorScheme.primary.withValues(alpha: 0.2))
            : BorderSide.none
        ),
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        trailing: isSelected
        ? Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 22)
        : null,
        onTap: () async {
          Navigator.pop(context);
          await Future.delayed(const Duration(milliseconds: 150));
          if (context.mounted) {
            await context.setLocale(locale);
            ref.read(localeProvider.notifier).state = (locale.countryCode?.isNotEmpty == true)
                ? '${locale.languageCode}_${locale.countryCode}'
                : locale.languageCode;
          }
        },
      ),
    );
  }
}
