import 'dart:developer';

import 'package:fourtyninehub/features/ride/Authentication/data/models/base_part_model.dart';

class PartModel {
  final BasePartModel part;
  final bool active;

  PartModel({required this.part, required this.active});

  factory PartModel.fromJson({required Map<String, dynamic> json, required String type}) {
    log(json.toString());
    return PartModel(
        part: BasePartModel.fromJson(json: json['part'], type: type), active: json['active']);
  }
}
