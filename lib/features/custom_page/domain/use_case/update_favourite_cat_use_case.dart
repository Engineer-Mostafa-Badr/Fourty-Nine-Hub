import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../reposiory/custom_page_repository.dart';

class UpdateFavouriteCatUseCase extends UseCase<bool, FavouriteCatParams> {
  final CustomPageRepository _customPageRepository;

  UpdateFavouriteCatUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(FavouriteCatParams params) async {
    return await _customPageRepository.updateFavouriteCat(params);
  }
}

class FavouriteCatParams {
  final bool medicalService;
  final bool homeService;
  final bool craft;
  final bool realEstate;
  final bool equipment;
  final bool spareParts;
  final bool cars;
  final bool vehicles;
  final bool smoking;
  final bool remnants;
  final bool rawMaterials;
  final bool wholesaleTrade;
  final bool homeEssentials;
  final bool mobilesTablets;
  final bool electricalDevices;
  final bool doctorJob;
  final bool technology;
  final bool packaging;
  final bool projects;
  final bool computersCameras;
  final bool marketingSales;
  final bool talent;
  final bool scenery;
  final bool accountantJob;
  final bool engineerJob;
  final bool events;
  final bool musicalInstruments;
  final bool travelTourism;
  final bool education;
  final bool handmades;
  final bool otherJob;
  final bool fitness;
  final bool libraries;
  final bool healthyTools;
  final bool jewelryWatches;
  final bool accessories;
  final bool charitys;
  final bool collectiblesGifts;
  final bool discountsOffers;
  final bool fashionBeauty;
  final bool animals;
  final bool ports;
  final bool dating;
  final bool farming;
  final bool governmentServices;
  final bool social;

  FavouriteCatParams(
      {required this.medicalService,
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

  Map<String, dynamic> toJson() {
    return {
      'MedicalService': medicalService,
      'HomeService': homeService,
      'Craft': craft,
      'RealEstate': realEstate,
      'Equipment': equipment,
      'SpareParts': spareParts,
      'Cars': cars,
      'Vehicles': vehicles,
      'Smoking': smoking,
      'Remnants': remnants,
      'RawMaterials': rawMaterials,
      'WholesaleTrade': wholesaleTrade,
      'HomeEssentials': homeEssentials,
      'MobilesTablets': mobilesTablets,
      'ElectricalDevices': electricalDevices,
      'DoctorJob': doctorJob,
      'Technology': technology,
      'Packaging': packaging,
      'Projects': projects,
      'ComputersCameras': computersCameras,
      'MarketingSales': marketingSales,
      'Talent': talent,
      'Scenery': scenery,
      'AccountantJob': accountantJob,
      'EngineerJob': engineerJob,
      'Events': events,
      'MusicalInstruments': musicalInstruments,
      'TravelTourism': travelTourism,
      'Education': education,
      'Handmades': handmades,
      'OtherJob': otherJob,
      'Fitness': fitness,
      'Libraries': libraries,
      'HealthyTools': healthyTools,
      'JewelryWatches': jewelryWatches,
      'Accessories': accessories,
      'Charitys': charitys,
      'CollectiblesGifts': collectiblesGifts,
      'DiscountsOffers': discountsOffers,
      'FashionBeauty': fashionBeauty,
      'Animals': animals,
      'Ports': ports,
      'Dating': dating,
      'Farming': farming,
      'GovernmentServices': governmentServices,
      'Social': social,
    };
  }
}
