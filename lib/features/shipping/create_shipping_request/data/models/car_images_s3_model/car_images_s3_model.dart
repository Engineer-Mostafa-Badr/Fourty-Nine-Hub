import 'car_image.dart';

class CarImagesS3Model {
  List<int>? updateImageIndex;
  List<CarImage>? carImages;

  CarImagesS3Model({this.updateImageIndex, this.carImages});

  factory CarImagesS3Model.fromJson(Map<String, dynamic> json) {
    return CarImagesS3Model(
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
