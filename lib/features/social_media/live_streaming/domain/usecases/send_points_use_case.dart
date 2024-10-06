import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/repository/live_repository.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';

class SendPointsUseCase extends NormalUseCase<Future<void>, PointsParams>{
  final LiveRepository _liveRepository;

  SendPointsUseCase(this._liveRepository);
  @override
  Future<void> call(PointsParams params) {
    return _liveRepository.sendPoints(params);
  }

}