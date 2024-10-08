import 'package:fourtyninehub/core/extensions/file_extension.dart';

class MessageMediaEntity {
  String id;
  String url;
  FileTypeEnum type;
  String? fileName;
  int? fileSize;
  MessageMediaEntity(
      {required this.id,
      required this.url,
      required this.type,
      this.fileName,
      this.fileSize});
}
