class FavouriteCatFeature {
  final String nameEn;
  final String nameAr;
  final bool enabled;

  FavouriteCatFeature({
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
  });
}

class FavouriteCatEntity {
  final String id;
  final String userId;
  final FavouriteCatFeature marriage;
  final FavouriteCatFeature homeService;
  final FavouriteCatFeature craft;
  final FavouriteCatFeature realEstate;
  final FavouriteCatFeature cars;
  final FavouriteCatFeature smoking;
  final FavouriteCatFeature homeEssentials;
  final FavouriteCatFeature technology;
  final FavouriteCatFeature projects;
  final FavouriteCatFeature computersCameras;
  final FavouriteCatFeature musicalInstruments;
  final FavouriteCatFeature travelTourism;
  final FavouriteCatFeature libraries;
  final FavouriteCatFeature fashionBeauty;
  final FavouriteCatFeature animals;
  final FavouriteCatFeature farming;
  final FavouriteCatFeature governmentServices;
  final FavouriteCatFeature jobs;
  final FavouriteCatFeature industry;

  FavouriteCatEntity(
      {required this.id,
      required this.userId,
      required this.marriage,
      required this.homeService,
      required this.craft,
      required this.realEstate,
      required this.cars,
      required this.smoking,
      required this.industry,
      required this.homeEssentials,
      required this.technology,
      required this.projects,
      required this.computersCameras,
      required this.musicalInstruments,
      required this.travelTourism,
      required this.libraries,
      required this.fashionBeauty,
      required this.animals,
      required this.farming,
      required this.governmentServices,
      required this.jobs});
}
