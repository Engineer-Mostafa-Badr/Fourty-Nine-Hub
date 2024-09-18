import 'package:fourtyninehub/core/extensions/file_extension.dart';

class MessageMediaEntity {
  String id;
  String url;
  FileTypeEnum type;
  MessageMediaEntity({required this.id, required this.url, required this.type});
}
