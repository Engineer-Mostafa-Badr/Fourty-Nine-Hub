import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/profile_repository.dart';

class UnsubscribeFromChannelUseCase extends UseCase<String, String> {
  final ProfileRepository repository;

  UnsubscribeFromChannelUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String profileId) async {
    return await repository.unsubscribeFromChannel(profileId);
  }
}