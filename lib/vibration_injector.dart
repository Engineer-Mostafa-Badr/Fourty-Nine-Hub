import 'dart:io';
import 'helpers/manage_vibration.dart';

void main() async {
  final dir = Directory.current;
  final dartFiles = dir.listSync(recursive: true).where(
    (file) =>
        file.path.endsWith('.dart') &&
        !file.path.contains('build') &&
        FileSystemEntity.isFileSync(file.path),
  );

  for (final file in dartFiles) {
    List<String> lines;
    try {
      lines = await File(file.path).readAsLines();
    } catch (e) {
      print('⚠️ Skipped (no access): ${file.path}');
      continue;
    }

    bool modified = false;
    final buffer = StringBuffer();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Match onTap or onPressed with optional async and open {
      final onTapOrPressedReg = RegExp(r'(onTap|onPressed)\s*:\s*\(\)\s*(async\s*)?{');

      if (onTapOrPressedReg.hasMatch(line)) {
        // Check next lines for vibration call
        bool foundVibration = false;
        bool isCommented = false;

        for (int j = i + 1; j < lines.length && j < i + 10; j++) {
          final checkLine = lines[j].trim();
          if (checkLine.contains('ManageVibration.vibrate()')) {
            foundVibration = true;
            if (checkLine.startsWith('//') || checkLine.contains('// ManageVibration.vibrate()')) {
              isCommented = true;
            }
            break;
          }
          if (checkLine.contains('}')) break;
        }

        buffer.writeln(line);

        if (!foundVibration) {
          // Add the vibration call on the next line
          buffer.writeln('      ManageVibration.vibrate();');
          modified = true;
        } else if (isCommented) {
          buffer.writeln('      // موجود لكنه متكومنت، لم يتم التعديل');
        }

      } else {
        buffer.writeln(line);
      }
    }

    if (modified) {
      await File(file.path).writeAsString(buffer.toString());
      print('✅ Modified: ${file.path}');
    }
  }

  print('\n✔️ Done injecting ManageVibration.vibrate();');
}