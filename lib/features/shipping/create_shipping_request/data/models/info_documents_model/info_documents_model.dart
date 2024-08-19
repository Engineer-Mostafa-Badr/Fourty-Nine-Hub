import 'document.dart';

class InfoDocumentsModel {
  Document? document;

  InfoDocumentsModel({this.document});

  factory InfoDocumentsModel.fromJson(Map<String, dynamic> json) {
    return InfoDocumentsModel(
      document: json['document'] == null
          ? null
          : Document.fromJson(json['document'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'document': document?.toJson(),
      };
}
