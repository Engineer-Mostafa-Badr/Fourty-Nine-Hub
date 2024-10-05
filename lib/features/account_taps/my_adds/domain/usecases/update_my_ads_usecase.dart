import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/my_adds/domain/repositories/my_ads_repo.dart';
import '../../../../../../core/abstract/use_case.dart';

class UpdateMyAdsUseCase extends UseCase<bool, UpdateMyAdsParams> {
  final MyAdsRepo _repo;

  UpdateMyAdsUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(UpdateMyAdsParams params) {
    return _repo.updateMyAds(params);
  }
}

class UpdateMyAdsParams {
  final String id;
  final String title;
  final String subCategoryId;
  final String mainCategoryId;
  final String desc;
  final String phone;
  final String images;

  UpdateMyAdsParams(
      {required this.id,
      required this.title,
      required this.subCategoryId,
      required this.mainCategoryId,
      required this.desc,
      required this.phone,
      required this.images});

  Map<String, dynamic> toJson() => {
        title: "title",
        subCategoryId: "subCategoryId",
        mainCategoryId: "mainCategoryId",
        desc: "desc",
        phone: "phone",
        images: "images",
      };
}
