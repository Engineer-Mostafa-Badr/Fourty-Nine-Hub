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
  final bool animals;
  final bool cars;
  final bool collectiblesGifts;
  final bool computersCameras;
  final bool craft;
  final bool dating;
  final bool discountsOffers;
  final bool doctorJob;
  final bool electricalDevices;
  final bool equipment;
  final bool farming;
  final bool fashionBeauty;
  final bool governmentServices;
  final bool homeEssentials;
  final bool homeService;
  final bool marketingSales;
  final bool medicalService;
  final bool mobilesTablets;
  final bool packaging;
  final bool ports;
  final bool projects;
  final bool rawMaterials;
  final bool realEstate;
  final bool remnants;
  final bool smoking;
  final bool social;
  final bool spareParts;
  final bool technology;
  final bool vehicles;
  final bool wholesaleTrade;

  FavouriteCatParams(
      {required this.animals,
      required this.cars,
      required this.collectiblesGifts,
      required this.computersCameras,
      required this.craft,
      required this.dating,
      required this.discountsOffers,
      required this.doctorJob,
      required this.electricalDevices,
      required this.equipment,
      required this.farming,
      required this.fashionBeauty,
      required this.governmentServices,
      required this.homeEssentials,
      required this.homeService,
      required this.marketingSales,
      required this.medicalService,
      required this.mobilesTablets,
      required this.packaging,
      required this.ports,
      required this.projects,
      required this.rawMaterials,
      required this.realEstate,
      required this.remnants,
      required this.smoking,
      required this.social,
      required this.spareParts,
      required this.technology,
      required this.vehicles,
      required this.wholesaleTrade});

  Map<String, dynamic> toJson() {
    return {
      'Animals': animals,
      'Cars': cars,
      'CollectiblesGifts': collectiblesGifts,
      'ComputersCameras': computersCameras,
      'Craft': craft,
      'Dating': dating,
      'DiscountsOffers': discountsOffers,
      'DoctorJob': doctorJob,
      'ElectricalDevices': electricalDevices,
      'Equipment': equipment,
      'Farming': farming,
      'FashionBeauty': fashionBeauty,
      'GovernmentServices': governmentServices,
      'HomeEssentials': homeEssentials,
      'HomeService': homeService,
      'MarketingSales': marketingSales,
      'MedicalService': medicalService,
      'MobilesTablets': mobilesTablets,
      'Packaging': packaging,
      'Ports': ports,
      'Projects': projects,
      'RawMaterials': rawMaterials,
      'RealEstate': realEstate,
      'Remnants': remnants,
      'Smoking': smoking,
      'Social': social,
      'SpareParts': spareParts,
      'Technology': technology,
      'Vehicles': vehicles,
      'WholesaleTrade': wholesaleTrade,
    };
  }
}
