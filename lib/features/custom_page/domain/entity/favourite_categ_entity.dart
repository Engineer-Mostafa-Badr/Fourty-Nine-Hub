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
  final FavouriteCatFeature medicalService;
  final FavouriteCatFeature homeService;
  final FavouriteCatFeature craft;
  final FavouriteCatFeature realEstate;
  final FavouriteCatFeature equipment;
  final FavouriteCatFeature spareParts;
  final FavouriteCatFeature cars;
  final FavouriteCatFeature vehicles;
  final FavouriteCatFeature smoking;
  final FavouriteCatFeature remnants;
  final FavouriteCatFeature rawMaterials;
  final FavouriteCatFeature wholesaleTrade;
  final FavouriteCatFeature homeEssentials;
  final FavouriteCatFeature mobilesTablets;
  final FavouriteCatFeature electricalDevices;
  final FavouriteCatFeature doctorJob;
  final FavouriteCatFeature technology;
  final FavouriteCatFeature packaging;
  final FavouriteCatFeature projects;
  final FavouriteCatFeature computersCameras;
  final FavouriteCatFeature marketingSales;
  final FavouriteCatFeature talent;
  final FavouriteCatFeature scenery;
  final FavouriteCatFeature accountantJob;
  final FavouriteCatFeature engineerJob;
  final FavouriteCatFeature events;
  final FavouriteCatFeature musicalInstruments;
  final FavouriteCatFeature travelTourism;
  final FavouriteCatFeature education;
  final FavouriteCatFeature handmades;
  final FavouriteCatFeature otherJob;
  final FavouriteCatFeature fitness;
  final FavouriteCatFeature libraries;
  final FavouriteCatFeature healthyTools;
  final FavouriteCatFeature jewelryWatches;
  final FavouriteCatFeature accessories;
  final FavouriteCatFeature charitys;
  final FavouriteCatFeature collectiblesGifts;
  final FavouriteCatFeature discountsOffers;
  final FavouriteCatFeature fashionBeauty;
  final FavouriteCatFeature animals;
  final FavouriteCatFeature ports;
  final FavouriteCatFeature dating;
  final FavouriteCatFeature farming;
  final FavouriteCatFeature governmentServices;
  final FavouriteCatFeature social;

  FavouriteCatEntity(
      {required this.id,
      required this.userId,
      required this.medicalService,
      required this.homeService,
      required this.craft,
      required this.realEstate,
      required this.equipment,
      required this.spareParts,
      required this.cars,
      required this.vehicles,
      required this.smoking,
      required this.remnants,
      required this.rawMaterials,
      required this.wholesaleTrade,
      required this.homeEssentials,
      required this.mobilesTablets,
      required this.electricalDevices,
      required this.doctorJob,
      required this.technology,
      required this.packaging,
      required this.projects,
      required this.computersCameras,
      required this.marketingSales,
      required this.talent,
      required this.scenery,
      required this.accountantJob,
      required this.engineerJob,
      required this.events,
      required this.musicalInstruments,
      required this.travelTourism,
      required this.education,
      required this.handmades,
      required this.otherJob,
      required this.fitness,
      required this.libraries,
      required this.healthyTools,
      required this.jewelryWatches,
      required this.accessories,
      required this.charitys,
      required this.collectiblesGifts,
      required this.discountsOffers,
      required this.fashionBeauty,
      required this.animals,
      required this.ports,
      required this.dating,
      required this.farming,
      required this.governmentServices,
      required this.social});
}
