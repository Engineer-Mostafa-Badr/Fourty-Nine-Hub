import 'car_image.dart';

class CarImagesS3RequestModel {
  List<int>? updateImageIndex;
  List<CarImage>? carImages;

  CarImagesS3RequestModel({this.updateImageIndex, this.carImages});

  factory CarImagesS3RequestModel.fromJson(Map<String, dynamic> json) {
    return CarImagesS3RequestModel(
      updateImageIndex: json['updateImageIndex'] as List<int>?,
      carImages: (json['carImages'] as List<dynamic>?)
          ?.map((e) => CarImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'updateImageIndex': updateImageIndex,
        'carImages': carImages?.map((e) => e.toJson()).toList(),
      };
}
