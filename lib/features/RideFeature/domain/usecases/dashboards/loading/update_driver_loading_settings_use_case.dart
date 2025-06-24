import 'package:dartz/dartz.dart';

import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../../../entities/dashboards/create_non_track_offer_entity.dart';
import '../../../entities/dashboards/update_driver_settings_entity.dart';
import '../../../repositories/ride_repository.dart';
import '../../../repositories/trip_repository.dart';

class UpdateDriverSettingsLoadingUseCase
    extends UseCase<CreateNonTrackOfferEntity , UpdateDriverSettingsLoadingParams> {
  final TripRepository _repo;

  UpdateDriverSettingsLoadingUseCase(this._repo);

  @override
  Future<Either<Failure, CreateNonTrackOfferEntity >> call(UpdateDriverSettingsLoadingParams params) {
    return _repo.updateDriverLoadingSettings(params);
  }
}
class UpdateDriverSettingsLoadingParams {
  final bool isReady;
  final bool isVoiceCommentAlertsEnabled;



  UpdateDriverSettingsLoadingParams({
    required this.isReady,
    required this.isVoiceCommentAlertsEnabled,

  });

  Map<String, dynamic> toJson() => {
    'isReady': isReady,
    'isVoiceCommentAlertsEnabled': isVoiceCommentAlertsEnabled,

  };
}

