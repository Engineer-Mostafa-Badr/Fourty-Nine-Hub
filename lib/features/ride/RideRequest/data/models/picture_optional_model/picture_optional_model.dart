import 'criminal_record.dart';
import 'drag_analytics.dart';
import 'technical_examination.dart';

class PictureOptionalModel {
  DragAnalytics? dragAnalytics;
  CriminalRecord? criminalRecord;
  TechnicalExamination? technicalExamination;

  PictureOptionalModel({
    this.dragAnalytics,
    this.criminalRecord,
    this.technicalExamination,
  });

  factory PictureOptionalModel.fromJson(Map<String, dynamic> json) {
    return PictureOptionalModel(
      dragAnalytics: json['DragAnalytics'] == null
          ? null
          : DragAnalytics.fromJson(
              json['DragAnalytics'] as Map<String, dynamic>),
      criminalRecord: json['CriminalRecord'] == null
          ? null
          : CriminalRecord.fromJson(
              json['CriminalRecord'] as Map<String, dynamic>),
      technicalExamination: json['TechnicalExamination'] == null
          ? null
          : TechnicalExamination.fromJson(
              json['TechnicalExamination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'DragAnalytics': dragAnalytics?.toJson(),
        'CriminalRecord': criminalRecord?.toJson(),
        'TechnicalExamination': technicalExamination?.toJson(),
      };
}
