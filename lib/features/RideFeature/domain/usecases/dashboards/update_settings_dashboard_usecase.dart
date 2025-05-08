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
        required this.isReady,
        required this.enableSound,
        required this.subscriptionPlan,
        required this.favoriteCity,
        required this.subCategoriesActive,
    });

    final bool isReady;
    final bool enableSound;
    final String subscriptionPlan;
    final String favoriteCity;
    final List<SubCategoriesActive> subCategoriesActive;

    factory UpdateSettingsDashboardUsecaseParam.fromJson(Map<String, dynamic> json){ 
        return UpdateSettingsDashboardUsecaseParam(
            isReady: json["isReady"] ?? false,
            enableSound: json["isVoiceCommentAlertsEnabled"] ?? false,
            subscriptionPlan: json["subscriptionPlan"] ?? "",
            favoriteCity: json["favoriteCity"] ?? "",
            subCategoriesActive: json["subCategoriesActive"] == null ? [] : List<SubCategoriesActive>.from(json["subCategoriesActive"]!.map((x) => SubCategoriesActive.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "isReady": isReady,
        'isVoiceCommentAlertsEnabled': enableSound,
        "subscriptionPlan": subscriptionPlan,
        "favoriteCity": favoriteCity,
        "subCategoriesActive": subCategoriesActive.map((x) => x.toJson()).toList(),
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