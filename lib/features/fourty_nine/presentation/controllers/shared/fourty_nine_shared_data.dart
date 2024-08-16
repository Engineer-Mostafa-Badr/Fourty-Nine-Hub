import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';

class FourtyNineSharedData {

  FourtyNineSharedData._privateConstructor();

  static final FourtyNineSharedData _instance = FourtyNineSharedData._privateConstructor();

  static FourtyNineSharedData get instance => _instance;

   List<MainCategoryEntity> mainCategories = [];
}
