import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';

class GetCateogryRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repo;
  BannerModel bannerModel = BannerModel();
  GetCateogryRiderCubit({required this.repo}) : super(RiderInitial());
  getCateogryData() async {
    var response = await repo.getCateogry();
    response.fold(
      (l) {
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

  sortData(String subCateogryId) {
    var item = bannerModel.subCategories?.indexWhere(
      (element) => element.subCategoryId == subCateogryId,
    );
    if (item == -1) {
      return;
    }
    var removedItem = bannerModel.subCategories?.removeAt(item!);
    bannerModel.subCategories?.insert(0, removedItem!);
    emit(SuccessGetCateogyRider(model: bannerModel));
  }
}
