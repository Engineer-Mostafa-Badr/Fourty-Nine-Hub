import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/slider_item_entity.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/parent_main_category_entity.dart';
import '../../domain/repositories/fourty_nine_repository.dart';
import '../data_sources/remote_data_source/fourty_nine_remote_data_source.dart';

class FourtyNineRepositoryImpl implements FourtyNineRepository {
  final FourtyNineRemoteDataSource _fourtyNineRemoteDataSource;

  FourtyNineRepositoryImpl(this._fourtyNineRemoteDataSource);

  @override
  Future<Either<Failure, List<ParentMainCategoryEntity>>>
      getParentMainCategories() {
    return _fourtyNineRemoteDataSource.getParentMainCategories();
  }

  @override
  Future<Either<Failure, List<MainCategoryEntity>>> getMainCategories() {
    return _fourtyNineRemoteDataSource.getMainCategories();
  }

  @override
  Future<Either<Failure, List<SliderItemEntity>>> getSliderItems() {
        return _fourtyNineRemoteDataSource.getSliderItems();

  }
}
