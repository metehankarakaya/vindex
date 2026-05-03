import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/app_database.dart';
import '../constants/app_strings.dart';
import '../../database/daos/recurring_transactions_dao.dart';
import '../../database/daos/transactions_dao.dart';
import '../models/recurring_transaction_table.dart';
import '../models/transactions_table.dart';

enum ImportResult {
  success,
  invalidFile,
  cancelled,
  error,
}

class BackupService {

  final TransactionsDao _transactionsDao;
  final RecurringTransactionsDao _recurringTransactionsDao;

  BackupService(this._transactionsDao, this._recurringTransactionsDao);

  static const _header = 'VINDEX_BACKUP_V1';
  static const _transactionsSection = 'VINDEX_TRANSACTIONS';
  static const _recurringSection = 'VINDEX_RECURRING';
  // 32-byte key required for AES-256
  static const _aesKey = 'VINDEX_BACKUP_KEY_2024_SECURE_V1';
  static const _magic = [0x56, 0x42, 0x4B, 0x31]; // VBK1

  Uint8List _encrypt(String input) {
    final key = enc.Key.fromUtf8(_aesKey);
    final iv = enc.IV.fromSecureRandom(12);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encryptBytes(utf8.encode(input), iv: iv);
    final combined = Uint8List(4 + 12 + encrypted.bytes.length);
    combined.setAll(0, _magic);
    combined.setAll(4, iv.bytes);
    combined.setAll(16, encrypted.bytes);
    return combined;
  }

  static bool _hasVbkMagic(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == _magic[0] &&
           bytes[1] == _magic[1] &&
           bytes[2] == _magic[2] &&
           bytes[3] == _magic[3];
  }

  String _decrypt(Uint8List combined) {
    // skip 4-byte magic header
    if (combined.length <= 32) throw FormatException('Invalid backup data');
    final iv = enc.IV(Uint8List.fromList(combined.sublist(4, 16)));
    final cipherBytes = enc.Encrypted(Uint8List.fromList(combined.sublist(16)));
    final key = enc.Key.fromUtf8(_aesKey);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    return utf8.decode(encrypter.decryptBytes(cipherBytes, iv: iv));
  }

  String _escapeField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  Future<String> _buildCsvContent() async {
    final transactions = await _transactionsDao.getAllTransactions().first;
    final recurring = await _recurringTransactionsDao.getAllRecurringTransactions().first;

    final buffer = StringBuffer();
    buffer.writeln(_header);
    buffer.writeln(_transactionsSection);
    buffer.writeln('id,title,amountCents,category,type,createdAt');

    for (final t in transactions) {
      buffer.writeln('${t.id},${_escapeField(t.title)},${t.amountCents},${t.category},${t.type.name},${t.createdAt.toIso8601String()}');
    }

    buffer.writeln(_recurringSection);
    buffer.writeln('id,title,amountCents,category,type,frequency,startDate,endDate,isActive,lastProcessDate');

    for (final r in recurring) {
      buffer.writeln('${r.id},${_escapeField(r.title)},${r.amountCents},${r.category},${r.type.name},${r.frequency.name},${r.startDate.toIso8601String()},${r.endDate?.toIso8601String() ?? ''},${r.isActive},${r.lastProcessDate?.toIso8601String() ?? ''}');
    }

    return buffer.toString();
  }

  Future<void> exportBackup({required bool encrypted}) async {
    final content = await _buildCsvContent();
    final extension = encrypted ? 'vbk' : 'csv';
    final mimeType = encrypted ? 'application/octet-stream' : 'text/csv';

    final now = DateTime.now();
    final fileName = 'vindex_backup_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}.$extension';

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');

    if (encrypted) {
      await file.writeAsBytes(_encrypt(content));
    } else {
      await file.writeAsString(content);
    }

    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      subject: AppStrings.backupSubject.tr(),
    );
  }

  Future<ImportResult> importBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["csv", "vbk", "BIN"],
        withData: true,
      );

      if (result == null) return ImportResult.cancelled;

      final platformFile = result.files.single;
      final path = platformFile.path;

      final Uint8List bytes;
      if (platformFile.bytes != null) {
        bytes = platformFile.bytes!;
      } else if (path != null) {
        bytes = await File(path).readAsBytes();
      } else {
        return ImportResult.error;
      }

      final String content;

      if (_hasVbkMagic(bytes)) {
        try {
          content = _decrypt(bytes);
        } catch (_) {
          return ImportResult.invalidFile;
        }
      } else {
        content = utf8.decode(bytes);
      }

      final lines = content.split('\n');
      if (lines.isEmpty || lines[0].trim() != _header) {
        return ImportResult.invalidFile;
      }

      final transactionsIndex = lines.indexOf(_transactionsSection);
      final recurringIndex = lines.indexOf(_recurringSection);

      if (transactionsIndex == -1 || recurringIndex == -1) {
        return ImportResult.invalidFile;
      }

      final parsedTransactions = _parseTransactions(lines, transactionsIndex, recurringIndex);
      final parsedRecurring = _parseRecurring(lines, recurringIndex);

      await _transactionsDao.deleteAllTransactions();
      await _recurringTransactionsDao.deleteAllRecurringTransactions();

      for (final t in parsedTransactions) {
        await _transactionsDao.insertTransaction(t);
      }
      for (final r in parsedRecurring) {
        await _recurringTransactionsDao.insertRecurringTransactions(r);
      }

      return ImportResult.success;
    } catch (e) {
      return ImportResult.error;
    }
  }

  List<TransactionsCompanion> _parseTransactions(List<String> lines, int start, int end) {
    final result = <TransactionsCompanion>[];
    for (int i = start + 2; i < end; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final fields = _parseCsvLine(line);
      if (fields.length < 6) throw Exception('Invalid transaction line');
      final amountCents = int.parse(fields[2]);
      if (amountCents < 0 || amountCents > 999_999_999_99) continue;
      result.add(TransactionsCompanion(
        id: Value(fields[0]),
        title: Value(fields[1]),
        amountCents: Value(amountCents),
        category: Value(fields[3]),
        type: Value(TransactionType.values.byName(fields[4])),
        createdAt: Value(DateTime.parse(fields[5])),
      ));
    }
    return result;
  }

  List<RecurringTransactionsCompanion> _parseRecurring(List<String> lines, int start) {
    final result = <RecurringTransactionsCompanion>[];
    for (int i = start + 2; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final fields = _parseCsvLine(line);
      if (fields.length < 10) throw Exception('Invalid recurring line');
      final amountCents = int.parse(fields[2]);
      if (amountCents < 0 || amountCents > 999_999_999_99) continue;
      result.add(RecurringTransactionsCompanion(
        id: Value(fields[0]),
        title: Value(fields[1]),
        amountCents: Value(amountCents),
        category: Value(fields[3]),
        type: Value(TransactionType.values.byName(fields[4])),
        frequency: Value(RecurringFrequency.values.byName(fields[5])),
        startDate: Value(DateTime.parse(fields[6])),
        endDate: Value(fields[7].isEmpty ? null : DateTime.parse(fields[7])),
        isActive: Value(fields[8] == 'true'),
        lastProcessDate: Value(fields[9].isEmpty ? null : DateTime.parse(fields[9])),
      ));
    }
    return result;
  }

  List<String> _parseCsvLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    fields.add(buffer.toString());
    return fields;
  }

}
