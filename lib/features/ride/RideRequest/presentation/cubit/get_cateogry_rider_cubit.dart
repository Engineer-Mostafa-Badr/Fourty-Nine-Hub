import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/sub_category.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/routes/pages.dart';

class GetCateogryRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repo;
  BannerModel bannerModel = BannerModel();
  GetCateogryRiderCubit({required this.repo}) : super(RiderInitial());
  getCateogryData() async {
    var response = await repo.getCateogry();
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailureRiderState(failure: l));
      },
      (r) {
        BannerModel model = BannerModel.fromJson(r['data']);
        // log(model.subCategories.toString(), name: "slkdlskdjflskdjf");
        bannerModel = model;
        emit(SuccessGetCateogyRider(model: model));
      },
    );
  }

  void sortData(
    String subCateogryId, {
    List<SubCategory>? orginalList,
    bool fromRide = false,
  }) {
    if (orginalList == null || orginalList.isEmpty) return;

    var item = orginalList.indexWhere(
      (element) => element.subCategoryId == subCateogryId,
    );

    if (item == -1) {
      return;
    }

    List<SubCategoryEntity> workingList = orginalList.map((e) {
      return SubCategoryEntity(
        image: e.picture ?? "",
        nameAr: e.subCategoryNameAr ?? "",
        nameEn: e.subCategoryNameEn ?? "",
        hasAuction: false,
        id: e.subCategoryId ?? "",
        isFavorite: e.isFavorite,
        numberOfContent: e.driverCount,
      );
    }).toList();

    var removedItem = workingList.removeAt(item);
    workingList.insert(0, removedItem);

    emit(SuccessGetCateogyRider(
        model: bannerModel, editedCategoryList: workingList));
  }
}
