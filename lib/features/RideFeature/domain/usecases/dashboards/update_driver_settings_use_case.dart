import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/dashboards/create_non_track_offer_entity.dart';
import '../../entities/dashboards/update_driver_settings_entity.dart';
import '../../repositories/ride_repository.dart';



class UpdateDriverSettingsUseCase
    extends UseCase<UpdateDriverSettingsEntity , UpdateDriverSettingsParams> {
  final RideRepository _repo;

  UpdateDriverSettingsUseCase(this._repo);

  @override
  Future<Either<Failure, UpdateDriverSettingsEntity >> call(UpdateDriverSettingsParams params) {
    return _repo.updateDriverSettings(params);
  }
}
class UpdateDriverSettingsParams {
  final bool isReady;
  final bool isVoiceCommentAlertsEnabled;



  UpdateDriverSettingsParams({
    required this.isReady,
    required this.isVoiceCommentAlertsEnabled,

  });

  Map<String, dynamic> toJson() => {
    'isReady': isReady,
    'isVoiceCommentAlertsEnabled': isVoiceCommentAlertsEnabled,

  };
}

