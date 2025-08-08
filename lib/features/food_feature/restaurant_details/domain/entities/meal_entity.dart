import '../../data/models/variation_model.dart';

import '../../../../../res/style/const.dart';
import '../../data/models/option_model.dart';

class MealEntity {
  final String id;
  final String name;
  final String description;
  final List<String> pictures;
  final num price;
  final num oldPrice;
  final List<VariationModel> variations;
  final List<OptionModel> addOns;
  String get image =>
      pictures.isNotEmpty ? pictures.first : UIConst.imagePlaceHolder;
  MealEntity(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictures,
      required this.price,
      required this.oldPrice,
      required this.variations,
      required this.addOns});
}
