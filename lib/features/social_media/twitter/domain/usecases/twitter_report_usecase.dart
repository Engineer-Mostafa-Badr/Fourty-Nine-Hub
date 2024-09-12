// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final String? comeWithYouTrip;
  TwitterReportParams({
    required this.category,
    required this.userId,
    required this.reason,
    required this.content,
    required this.categoryId,
    this.comeWithYouTrip,
  });
  Map<String, dynamic> toJson() => {
        'category': category,
        'userId': userId,
        'reason': reason,
        'content': content,
        'categoryId': categoryId,
        'subCategory': '66a3583454e6e337915514db',
        'comeWithYouTrip': comeWithYouTrip,
      };

  @override
  String toString() {
    return 'TwitterReportParams(category: $category, userId: $userId, reason: $reason, content: $content, categoryId: $categoryId, comeWithYouTrip: $comeWithYouTrip)';
  }
}
