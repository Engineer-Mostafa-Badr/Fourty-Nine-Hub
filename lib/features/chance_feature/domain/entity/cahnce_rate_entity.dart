import 'package:equatable/equatable.dart';

class ChanceRateEntity extends Equatable {
  final int userContribution;
  final int totalContributions;
  final double contributionPercentage;

  const ChanceRateEntity({
    required this.userContribution,
    required this.totalContributions,
    required this.contributionPercentage,
  });

  @override
  List<Object?> get props =>
      [userContribution, totalContributions, contributionPercentage];
}
