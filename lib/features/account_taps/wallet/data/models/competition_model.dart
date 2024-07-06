import '../../domain/entities/competition_entity.dart';

class CompetitionModel extends CompetitionEntity {
  CompetitionModel(
      {required super.id,
      required super.name,
      required super.value,
      required super.target,
      required super.points});
  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'],
      name: json['name'],
      value: json['value'],
      target: json['target'],
      points: json['points'],
    );
  }
}
