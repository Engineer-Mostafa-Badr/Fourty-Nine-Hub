import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class SendGreetMessageUseCase extends UseCase<bool, SendGreetMessageParams> {
  final SocialPostsRepo _repo;
  SendGreetMessageUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(SendGreetMessageParams params) async {
    return await _repo.sendGreetMessage(params: params);
  }
}

class SendGreetMessageParams {
  final String userId;
  final String message;

  SendGreetMessageParams({required this.userId, required this.message});

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'message': message,
      };
}
