import '../../../../../competition/data/models/competion_model.dart';
import '../../../domain/entities/gift_entities.dart';

class CompetitionWalletModel extends CompetitionWallet {
  const CompetitionWalletModel({
    required CompetitionModel competition,
    required super.countOfRequest,
  }) : super(
    competition: competition as Competition,
  );

  factory CompetitionWalletModel.fromJson(Map<String, dynamic> json) {
    return CompetitionWalletModel(
      competition: CompetitionModel.fromJson(json['competition_id']),
      countOfRequest: json['countOfRequest'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'competition_id': (competition as CompetitionModel).toJson(),
      'countOfRequest': countOfRequest,
    };
  }
}
