import '../../data/models/option_model.dart';
import 'option_entity.dart';

class VariationEntity {
  final String id;
  final String name;
  final List<OptionModel> options;
  VariationEntity({
    required this.id, 
    required this.name, 
    required this.options,
  });
}
