import '../../domain/entities/slider_item_entity.dart';

class SliderItemModel extends SliderItemEntity {
  SliderItemModel(
      {required super.id,
      required super.route,
      required super.title,
      required super.subTitle,
      required super.image});
  factory SliderItemModel.fromJson(Map<String, dynamic> json) {
    return SliderItemModel(
      id: json['_id'] ??'',
      route: json['route'] ??"",
      title: json['title'] ??'',
      subTitle: json['subTitle'] ??'',
      image: json['image'] ??'',
    );
  }
}
