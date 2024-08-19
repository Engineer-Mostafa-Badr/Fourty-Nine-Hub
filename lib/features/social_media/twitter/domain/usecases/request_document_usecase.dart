import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class RequestDocumentUseCase extends UseCase<bool, TwitterDocumentationParams> {
  final TwitterRepo _repo;
  RequestDocumentUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(TwitterDocumentationParams params) async {
    return await _repo.requestDocument(params: params);
  }
}

class TwitterDocumentationParams {
  final List<String> mediaIds;
  final String name;

  TwitterDocumentationParams({
    required this.mediaIds,
    required this.name,
  });
  Map<String, dynamic> toJson() => {
        'mediaIds': mediaIds,
        'name': name,
        'subCategory': '66a3583454e6e337915514db'
      };
}
