import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/trip_repository.dart';

class UpdateSettingsDashboardUsecase{
  final TripRepository repository;

  UpdateSettingsDashboardUsecase(this.repository);

  Future<Either<Failure, bool>> call(UpdateSettingsDashboardUsecaseParam params) async {
    return repository.updateSettings(params);
  }
}
class UpdateSettingsDashboardUsecaseParam {
    UpdateSettingsDashboardUsecaseParam({
        this.isReady,
        this.isComfort,
        this.isNonSmoking,
        this.isCaptainShare,
        this.enableSound,
        this.subscriptionPlan,
        this.perKm,
        this.favoriteCity,
        this.subCategoriesActive,
    });

    final bool? isReady;
    final bool? isComfort;
    final bool? isNonSmoking;
    final bool? isCaptainShare;
    final bool? enableSound;
    final String? subscriptionPlan;
    final num? perKm;
    final String? favoriteCity;
    final List<SubCategoriesActive>? subCategoriesActive;

    factory UpdateSettingsDashboardUsecaseParam.fromJson(Map<String, dynamic> json){ 
        return UpdateSettingsDashboardUsecaseParam(
            isReady: json["isReady"] ?? false,
            isComfort: json["isComfort"] ?? false,
            isNonSmoking: json["isNonSmoking"] ?? false,
            enableSound: json["isVoiceCommentAlertsEnabled"] ?? false,
            isCaptainShare: json["isCaptainShareEnabled"] ?? false,
            subscriptionPlan: json["subscriptionPlan"] ?? "",
            perKm: json["pricingPerKm"] ?? 0,
            favoriteCity: json["favoriteCity"] ?? "",
            subCategoriesActive: json["subCategoriesActive"] == null ? [] : List<SubCategoriesActive>.from(json["subCategoriesActive"]!.map((x) => SubCategoriesActive.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        if(isReady != null)"isReady": isReady,
        if(isComfort != null)"isComfort": isComfort,
        if(isNonSmoking != null)"isNonSmoking": isNonSmoking,
        if(isCaptainShare != null)"isCaptainShareEnabled": isCaptainShare,
        if(enableSound != null)'isVoiceCommentAlertsEnabled': enableSound,
        if(subscriptionPlan != null)"subscriptionPlan": subscriptionPlan,
        if(favoriteCity != null)"favoriteCity": favoriteCity,
        if(perKm != null)"pricingPerKm": perKm,
        if(subCategoriesActive != null&& subCategoriesActive!=[])"subCategoriesActive": subCategoriesActive?.map((x) => x.toJson()).toList(),
    };

}

class SubCategoriesActive {
    SubCategoriesActive({
        required this.subcategoryId,
        required this.isActive,
    });

    final String subcategoryId;
    final bool isActive;

    factory SubCategoriesActive.fromJson(Map<String, dynamic> json){ 
        return SubCategoriesActive(
            subcategoryId: json["subcategoryId"] ?? "",
            isActive: json["isActive"] ?? false,
        );
    }

    Map<String, dynamic> toJson() => {
        "subcategoryId": subcategoryId,
        "isActive": isActive,
    };

}