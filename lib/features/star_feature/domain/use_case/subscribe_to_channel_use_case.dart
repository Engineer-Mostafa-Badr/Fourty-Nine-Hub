import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/profile_repository.dart';

class SubscribeToChannelUseCase extends UseCase<String, String> {
  final ProfileRepository repository;

  SubscribeToChannelUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String profileId) async {
    return await repository.subscribeToChannel(profileId);
  }
}