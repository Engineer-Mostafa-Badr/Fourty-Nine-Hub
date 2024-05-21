import 'package:equatable/equatable.dart';

import '../../../res/style/const.dart';



class SubCategory extends Equatable {
  final String id;
  final String name;
  final bool isHidden;
  final String parent;
  final int paymentFactor;
  final int portion;
  final int providerPortion;
  final int total;
  final String picture;
  final String? description;
  bool? selected = true;

  bool isFavorite;

  SubCategory({
    required this.id,
    this.description,
    required this.name,
    required this.isHidden,
    required this.parent,
    required this.paymentFactor,
    required this.portion,
    required this.providerPortion,
    required this.picture,
    this.selected,
    required this.total,
    required this.isFavorite,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"] as String,
        name: json["name"] as String,
        description: json["description"] as String?,
        isHidden: json["is_hidden"] as bool,
        parent: json["parent"] as String,
        paymentFactor: json["payment_factor"] as int,
        portion: json["portion"] as int,
        providerPortion: json["provider_portion"] as int,
        total: json["total"] as int? ?? 0,
        picture: UIConst.imageBaseUrl + (json['picture'] as String),
        isFavorite: json['is_favorite'] as bool? ?? false,
      );

  @override
  List<Object> get props => [id];
}
