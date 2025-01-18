import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class DragAnalysisPartModel implements BasePartModel {
  String? drug;
  String? drugDate;
  String? criminal;
  String? criminalDate;
  String? technical;
  String? technicalDate;
  DragAnalysisPartModel(
      {this.criminal,
      this.criminalDate,
      this.drug,
      this.drugDate,
      this.technical,
      this.technicalDate});
  factory DragAnalysisPartModel.fromJson(Map<String, dynamic>? json) {
    return DragAnalysisPartModel(
        criminal: json?['criminal'],
        criminalDate: json?['criminalDate'],
        drug: json?['drug'],
        drugDate: json?['drugDate'],
        technical: json?['technical'],
        technicalDate: json?['technicalDate']);
  }
  @override
  toJson() {
    return {
      "criminal": criminal,
      "criminalDate": criminalDate,
      "drug": drug,
      "drugDate": drugDate,
      "technical": technical,
      "technicalDate": technicalDate,
    };
  }
}
