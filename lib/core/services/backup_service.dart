import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../database/app_database.dart';
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
  static const _xorKey = 'VINDEX_KEY';

  String _xorCipher(String input) {
    return String.fromCharCodes(
      Iterable.generate(input.length, (i) =>
      input.codeUnitAt(i) ^ _xorKey.codeUnitAt(i % _xorKey.length)),
    );
  }

  String _encrypt(String input) {
    return base64Encode(utf8.encode(_xorCipher(input)));
  }

  String _decrypt(String input) {
    return _xorCipher(utf8.decode(base64Decode(input)));
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

  Future<String> exportBackup({required bool encrypted}) async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) throw Exception('Permission denied');

    final content = await _buildCsvContent();
    final finalContent = encrypted ? _encrypt(content) : content;
    final extension = encrypted ? 'vbk' : 'csv';

    final now = DateTime.now();
    final fileName = 'vindex_backup_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}.$extension';

    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(finalContent);

    return fileName;
  }

  Future<ImportResult> importBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["csv", "vbk", "BIN"],
      );

      if (result == null) return ImportResult.cancelled;

      final path = result.files.single.path;
      if (path == null) return ImportResult.error;

      final file = File(path);
      String content = await file.readAsString();

      if (path.endsWith('.vbk')) {
        content = _decrypt(content);
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
      result.add(TransactionsCompanion(
        id: Value(fields[0]),
        title: Value(fields[1]),
        amountCents: Value(int.parse(fields[2])),
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
      result.add(RecurringTransactionsCompanion(
        id: Value(fields[0]),
        title: Value(fields[1]),
        amountCents: Value(int.parse(fields[2])),
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
