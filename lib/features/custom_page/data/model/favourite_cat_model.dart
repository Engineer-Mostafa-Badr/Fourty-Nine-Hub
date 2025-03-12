import 'package:fourtyninehub/features/custom_page/domain/entity/favourite_categ_entity.dart';

class FavouriteCatModel extends FavouriteCatEntity {
  FavouriteCatModel(
      {required super.id,
      required super.userId,
      required super.marriage,
      required super.industry,
      required super.homeService,
      required super.craft,
      required super.realEstate,
      required super.cars,
      required super.smoking,
      required super.homeEssentials,
      required super.technology,
      required super.projects,
      required super.computersCameras,
      required super.musicalInstruments,
      required super.travelTourism,
      required super.libraries,
      required super.fashionBeauty,
      required super.animals,
      required super.farming,
      required super.governmentServices,
      required super.jobs, required super.fitness});

  factory FavouriteCatModel.fromJson(Map<String, dynamic> json) {
    FavouriteCatFeature parseFeature(Map<String, dynamic> featureJson) {
      return FavouriteCatFeature(
        nameEn: featureJson['nameEn'],
        nameAr: featureJson['nameAr'],
        enabled: featureJson['enabled'],
        banner: featureJson['banner'],
      );
    }

    return FavouriteCatModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      marriage: parseFeature(json['Marriage'] ?? false),
      homeService: parseFeature(json['Home Service'] ?? false),
      craft: parseFeature(json['Craft/Talent'] ?? false),
      realEstate: parseFeature(json['Real Estate'] ?? false),
      cars: parseFeature(json['Cars/Vehicles'] ?? false),
      smoking: parseFeature(json['Smoking'] ?? false),
      homeEssentials: parseFeature(json['Home Essentials'] ?? false),
      technology: parseFeature(json['Technology'] ?? false),
      projects: parseFeature(json['Projects'] ?? false),
      computersCameras: parseFeature(json['Computers/Mobiles'] ?? false),
      musicalInstruments: parseFeature(json['Musical Instruments'] ?? false),
      travelTourism: parseFeature(json['Tourism/Entertainment'] ?? false),
      libraries: parseFeature(json['Libraries/Education'] ?? false),
      fashionBeauty: parseFeature(json['Fashion/Beauty'] ?? false),
      animals: parseFeature(json['Animals'] ?? false),
      farming: parseFeature(json['Farming'] ?? false),
      governmentServices: parseFeature(json['Government/charity'] ?? false),
      jobs: parseFeature(json['Jobs'] ?? false),
      industry: parseFeature(json['Industry'] ?? false),
      fitness: parseFeature(json['Fitness'] ?? false),

    );
  }
}
