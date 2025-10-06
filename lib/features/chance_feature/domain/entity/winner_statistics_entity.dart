import 'package:equatable/equatable.dart';

class WinnerStatisticsEntity extends Equatable {
  final int totalWinner;
  final int totalAds;

  const WinnerStatisticsEntity({
    required this.totalWinner,
    required this.totalAds,
  });

  @override
  List<Object?> get props => [totalWinner, totalAds];
}