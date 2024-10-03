import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/carpool_route_info_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/usecases/get_price_carpool_usecase.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

part 'get_price_carpool_state.dart';

class GetPriceCarpoolCubit extends Cubit<GetPriceCarpoolState> {
  final GetPriceCarpoolUsecase getPriceCarpoolUsecase;
  CarpoolRouteInfoModel? carpoolRouteInfoModel;

  GetPriceCarpoolCubit({
    required this.getPriceCarpoolUsecase,
  }) : super(GetPriceCarpoolInitial());

  Future<void> getPriceCarpool({required GetPriceCarpoolParam getPriceCarpoolParam}) async {
    emit(GetPriceCarpoolLoading());
    final response = await getPriceCarpoolUsecase.call(
      getPriceCarpoolParam: getPriceCarpoolParam,
    );
    response.fold(
      (Failure failure) => emit(
        GetPriceCarpoolFailed(Labels.errorHappened),
      ),
      (data) {
        carpoolRouteInfoModel = data;
        emit(GetPriceCarpoolSuccess(data));
      },
    );
  }
}
