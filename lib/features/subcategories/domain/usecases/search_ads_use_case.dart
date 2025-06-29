import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import '../../../../core/abstract/use_case.dart';

class SearchAdsUseCase extends UseCase<List<AdModel>, SearchAdsParams> {
  final SubcategoriesRepo _repo;

  SearchAdsUseCase(this._repo);

  @override
  Future<Either<Failure, List<AdModel>>> call(SearchAdsParams params) {
    return _repo.searchAds(params);
  }
}

class SearchAdsParams {
  final String searchText;
  final String mainCategoryId;

  SearchAdsParams({
    required this.searchText,
    required this.mainCategoryId,
  });

  Map<String, dynamic> toJson() => {
        'searchText': searchText,
      };
}
