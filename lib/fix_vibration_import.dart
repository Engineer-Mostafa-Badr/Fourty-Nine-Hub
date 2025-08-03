import 'dart:io';

void main() async {
  final dir = Directory.current;
  final dartFiles = dir.listSync(recursive: true).where(
    (file) =>
        file.path.endsWith('.dart') &&
        !file.path.contains('build') &&
        FileSystemEntity.isFileSync(file.path),
  );

  for (final file in dartFiles) {
    final filePath = file.path;
    List<String> lines;

    try {
      lines = await File(filePath).readAsLines();
    } catch (e) {
      print('⚠️ Skipped (no access): $filePath');
      continue;
    }

    // Check if file contains usage
    final hasVibrationCall = lines.any((line) =>
        line.contains('ManageVibration.vibrate()') &&
        !line.trimLeft().startsWith('//'));

    if (!hasVibrationCall) continue;

    // Check if import already exists
    final hasImport = lines.any(
        (line) => line.contains("import 'package:fourtyninehub/helpers/manage_vibration.dart';"));

    if (hasImport) continue;

    // Add import after other imports
    final insertIndex = lines.lastIndexWhere((line) => line.startsWith('import '));
    final before = lines.sublist(0, insertIndex + 1);
    final after = lines.sublist(insertIndex + 1);

    final updatedLines = [
      ...before,
      "import 'package:fourtyninehub/helpers/manage_vibration.dart';",
      ...after,
    ];

    await File(filePath).writeAsString(updatedLines.join('\n'));
    print('✅ Import added: $filePath');
  }

  print('\n🎯 Done: Added import to files missing it.');
}
