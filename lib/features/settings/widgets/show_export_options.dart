import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/backup_provider.dart';

class ExportOptionsSheet {
  static void show(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => _ExportOptionsContent(ref: ref),
    );
  }
}

class _ExportOptionsContent extends StatefulWidget {
  final WidgetRef ref;
  const _ExportOptionsContent({required this.ref});

  @override
  State<_ExportOptionsContent> createState() => _ExportOptionsContentState();
}

class _ExportOptionsContentState extends State<_ExportOptionsContent> {
  // null = idle, false = unencrypted loading, true = encrypted loading
  bool? _loadingEncrypted;

  Future<void> _export(bool encrypted) async {
    setState(() => _loadingEncrypted = encrypted);
    await widget.ref.read(backupServiceProvider).exportBackup(encrypted: encrypted);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = _loadingEncrypted != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: _loadingEncrypted == false
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.primary,
                        semanticsLabel: AppStrings.loading.tr(),
                      ),
                    )
                  : Icon(
                      Icons.lock_open_outlined,
                      color: isLoading
                          ? colorScheme.onSurface.withValues(alpha: 0.3)
                          : colorScheme.primary,
                    ),
              title: Text(
                AppStrings.exportUnencrypted.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isLoading ? colorScheme.onSurface.withValues(alpha: 0.3) : null,
                ),
              ),
              subtitle: Text(AppStrings.exportUnencryptedSubtitle.tr()),
              onTap: isLoading ? null : () => _export(false),
            ),
            const SizedBox(height: 8),
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              leading: _loadingEncrypted == true
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.secondary,
                        semanticsLabel: AppStrings.loading.tr(),
                      ),
                    )
                  : Icon(
                      Icons.lock_outlined,
                      color: isLoading
                          ? colorScheme.onSurface.withValues(alpha: 0.3)
                          : colorScheme.secondary,
                    ),
              title: Text(
                AppStrings.exportEncrypted.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isLoading ? colorScheme.onSurface.withValues(alpha: 0.3) : null,
                ),
              ),
              subtitle: Text(AppStrings.exportEncryptedSubtitle.tr()),
              onTap: isLoading ? null : () => _export(true),
            ),
          ],
        ),
      ),
    );
  }
}
