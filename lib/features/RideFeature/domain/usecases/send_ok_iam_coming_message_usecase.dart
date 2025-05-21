import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/ride_repository.dart';

class SendOkIamComingMessageUseCase {
  final RideRepository repository;

  SendOkIamComingMessageUseCase({required this.repository});

  Future<Either<Failure, bool>> call() {
    return repository.sendOkIamComing();
  }
}