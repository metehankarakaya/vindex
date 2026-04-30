import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/providers/backup_provider.dart';
import '../../../core/utils/vindex_snackbar.dart';

class ExportOptionsSheet {
  static void show(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
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
                leading: Icon(Icons.lock_open_outlined, color: colorScheme.primary),
                title: const Text("Şifresiz Export (.csv)",
                style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Excel veya Google Tablolar'da açılabilir"),
                onTap: () async {
                  Navigator.pop(context);
                  final fileName = await ref.read(backupServiceProvider).exportBackup(encrypted: false);
                  if (context.mounted) {
                    VindexSnackBar.showSnackBar(
                      context,
                      AppStrings.exportSuccessCsv.tr(args: [fileName]),
                      isSuccess: true
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                leading: Icon(Icons.lock_outlined, color: colorScheme.secondary),
                title: const Text("Şifreli Export (.vbk)",
                style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text("Sadece Vindex üzerinden geri yüklenebilir"),
                onTap: () async {
                  Navigator.pop(context);
                  final fileName = await ref.read(backupServiceProvider).exportBackup(encrypted: true);
                  if (context.mounted) {
                    VindexSnackBar.showSnackBar(
                      context,
                      AppStrings.exportSuccessVbk.tr(args: [fileName]),
                      isSuccess: true
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
