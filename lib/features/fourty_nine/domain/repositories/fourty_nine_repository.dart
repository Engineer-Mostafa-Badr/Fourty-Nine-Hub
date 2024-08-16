import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';

import '../../../../common/models/public/pagination_params.dart';
import '../../../../core/error/failure.dart';
import '../entities/parent_main_category_entity.dart';

abstract class FourtyNineRepository {
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories();

  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategories(
      {required PaginationParams params});
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems();
  Future<Either<Failure, Banner>> getBannerById({required String id});
}
