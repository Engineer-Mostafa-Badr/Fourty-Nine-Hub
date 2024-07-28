import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/repositories/twitter_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class TwitterReportUseCase extends UseCase<bool, TwitterReportParams> {
  final TwitterRepo _repo;
  TwitterReportUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(TwitterReportParams params) async {
    return await _repo.addReport(params: params);
  }
}



class TwitterReportParams {
  final String category;
  final String userId;
  final String reason;
  final String content;
  final String categoryId;
  TwitterReportParams({
    required this.category,
    required this.userId,
    required this.reason,
    required this.content,
    required this.categoryId,
  });
  Map<String, dynamic> toJson() => {
    'category': category,
    'userId': userId,
    'reason': reason,
    'content': content,
    'categoryId': categoryId,
  };
}
