import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class UpdateTripAutoAcceptByClientUseCase{
  final RideRepository repository;

  UpdateTripAutoAcceptByClientUseCase({required this.repository});

  Future<Either<Failure, bool>> call(UpdateTripAutoAcceptByClientUseCaseParams params) {
    return repository.updateTripAutoAcceptByClient(params);
  }
}
class UpdateTripAutoAcceptByClientUseCaseParams{
  final bool isAutoAccept;

  UpdateTripAutoAcceptByClientUseCaseParams({required this.isAutoAccept});

  //to json
  Map<String, dynamic> toJson() => {'isAutoAccept': isAutoAccept};
}