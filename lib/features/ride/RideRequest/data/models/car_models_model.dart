class CarModelsModel {
  final String? model;
  CarModelsModel({this.model});

  factory CarModelsModel.fromJson(Map<String, dynamic> json) {
    return CarModelsModel(model: json['model'].toString());
  }
}
