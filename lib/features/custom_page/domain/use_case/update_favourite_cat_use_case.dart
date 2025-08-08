import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';

import '../../data/model/update_custom_page_categorise_model.dart';
import '../reposiory/custom_page_repository.dart';

class UpdateFavouriteCatUseCase extends UseCase<bool, List<UpdateCustomPageCategoriesModel>> {
  final CustomPageRepository _customPageRepository;

  UpdateFavouriteCatUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(List<UpdateCustomPageCategoriesModel> params) async {
    return await _customPageRepository.updateFavouriteCat(params);
  }
}

// class FavouriteCatParams {
//   final bool medicalService;
//   final bool homeService;
//   final bool craft;
//   final bool realEstate;
//   final bool equipment;
//   final bool spareParts;
//   final bool cars;
//   final bool vehicles;
//   final bool smoking;
//   final bool remnants;
//   final bool rawMaterials;
//   final bool wholesaleTrade;
//   final bool homeEssentials;
//   final bool mobilesTablets;
//   final bool electricalDevices;
//   final bool doctorJob;
//   final bool technology;
//   final bool packaging;
//   final bool projects;
//   final bool computersCameras;
//   final bool marketingSales;
//   final bool talent;
//   final bool scenery;
//   final bool accountantJob;
//   final bool engineerJob;
//   final bool events;
//   final bool musicalInstruments;
//   final bool travelTourism;
//   final bool education;
//   final bool handmades;
//   final bool otherJob;
//   final bool fitness;
//   final bool libraries;
//   final bool healthyTools;
//   final bool jewelryWatches;
//   final bool accessories;
//   final bool charitys;
//   final bool collectiblesGifts;
//   final bool discountsOffers;
//   final bool fashionBeauty;
//   final bool animals;
//   final bool ports;
//   final bool dating;
//   final bool farming;
//   final bool governmentServices;
//   final bool social;
//
//   FavouriteCatParams(
//       {required this.medicalService,
//       required this.homeService,
//       required this.craft,
//       required this.realEstate,
//       required this.equipment,
//       required this.spareParts,
//       required this.cars,
//       required this.vehicles,
//       required this.smoking,
//       required this.remnants,
//       required this.rawMaterials,
//       required this.wholesaleTrade,
//       required this.homeEssentials,
//       required this.mobilesTablets,
//       required this.electricalDevices,
//       required this.doctorJob,
//       required this.technology,
//       required this.packaging,
//       required this.projects,
//       required this.computersCameras,
//       required this.marketingSales,
//       required this.talent,
//       required this.scenery,
//       required this.accountantJob,
//       required this.engineerJob,
//       required this.events,
//       required this.musicalInstruments,
//       required this.travelTourism,
//       required this.education,
//       required this.handmades,
//       required this.otherJob,
//       required this.fitness,
//       required this.libraries,
//       required this.healthyTools,
//       required this.jewelryWatches,
//       required this.accessories,
//       required this.charitys,
//       required this.collectiblesGifts,
//       required this.discountsOffers,
//       required this.fashionBeauty,
//       required this.animals,
//       required this.ports,
//       required this.dating,
//       required this.farming,
//       required this.governmentServices,
//       required this.social});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Medical Service': {'enabled': medicalService},
//       'Home Service': {'enabled': homeService},
//       'Craft': {'enabled': craft},
//       'Real Estate': {'enabled': realEstate},
//       'Equipment': {'enabled': equipment},
//       'Spare Parts': {'enabled': spareParts},
//       'Cars': {'enabled': cars},
//       'Vehicles': {'enabled': vehicles},
//       'Smoking': {'enabled': smoking},
//       'Remnants': {'enabled': remnants},
//       'Raw Materials': {'enabled': rawMaterials},
//       'Wholesale Trade': {'enabled': wholesaleTrade},
//       'Home Essentials': {'enabled': homeEssentials},
//       'Mobiles/Tablets': {'enabled': mobilesTablets},
//       'Electrical Devices': {'enabled': electricalDevices},
//       'Doctor Job': {'enabled': doctorJob},
//       'Technology': {'enabled': technology},
//       'Packaging': {'enabled': packaging},
//       'Projects': {'enabled': projects},
//       'Computers/Cameras': {'enabled': computersCameras},
//       'Marketing/Sales': {'enabled': marketingSales},
//       'Talent': {'enabled': talent},
//       'Scenery': {'enabled': scenery},
//       'Accountant Job': {'enabled': accountantJob},
//       'Engineer Job': {'enabled': engineerJob},
//       'Events': {'enabled': events},
//       'Musical Instruments': {'enabled': musicalInstruments},
//       'Travel/Tourism': {'enabled': travelTourism},
//       'Education': {'enabled': education},
//       'Handmades': {'enabled': handmades},
//       'Other Job': {'enabled': otherJob},
//       'Fitness': {'enabled': fitness},
//       'Libraries': {'enabled': libraries},
//       'Healthy Tools': {'enabled': healthyTools},
//       'Jewelry/Watches': {'enabled': jewelryWatches},
//       'Accessories': {'enabled': accessories},
//       'Charitys': {'enabled': charitys},
//       'Collectibles/Gifts': {'enabled': collectiblesGifts},
//       'Discounts/Offers': {'enabled': discountsOffers},
//       'Fashion/Beauty': {'enabled': fashionBeauty},
//       'Animals': {'enabled': animals},
//       'Ports': {'enabled': ports},
//       'Dating': {'enabled': dating},
//       'Farming': {'enabled': farming},
//       'Government Services': {'enabled': governmentServices},
//       'Social': {'enabled': social},
//     };
//   }
// }
