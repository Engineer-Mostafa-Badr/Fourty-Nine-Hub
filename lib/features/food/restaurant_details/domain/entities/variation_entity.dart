import 'option_entity.dart';

class VariationEntity {
  final int id;
  final String name;
  final List<OptionEntity> options;
  VariationEntity({
    required this.id, 
    required this.name, 
    required this.options,
  });
}
