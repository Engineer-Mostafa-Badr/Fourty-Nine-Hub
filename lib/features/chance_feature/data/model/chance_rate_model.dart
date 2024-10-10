import 'package:fourtyninehub/features/chance_feature/domain/entity/cahnce_rate_entity.dart';

class ChanceRateModel extends ChanceRateEntity {
  ChanceRateModel({
    required super.userContribution,
    required super.totalContributions,
    required super.contributionPercentage,
  });

  factory ChanceRateModel.fromJson(Map<String, dynamic> json) {
    return ChanceRateModel(
      userContribution: json['userContribution'],
      totalContributions: json['totalContributions'],
      contributionPercentage: json['contributionPercentage'],
    );
  }

}
