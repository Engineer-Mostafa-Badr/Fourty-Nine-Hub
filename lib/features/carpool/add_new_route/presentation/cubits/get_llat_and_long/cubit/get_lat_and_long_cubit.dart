import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/get_lat_long_from_address_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/get_lat_and_long_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/cubit/dest_get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'get_lat_and_long_state.dart';

class GetLatAndLongCubit extends Cubit<GetLatAndLongState> {
  final GetLatLongFromAddressRemoteDataSource
      getLatLongFromAddressRemoteDataSource;
  double? startLat;
  double? startLong;
  String type = '';
  String fromEn = '';
  GetLatAndLongCubit({required this.getLatLongFromAddressRemoteDataSource})
      : super(GetLatAndLongInitial());

  Future<void> getLatAndLong({
    required BuildContext context,
    required String address,
    required bool isStart,
    bool isTripJoin = false,
  }) async {
    emit(GetLatAndLongLoading());
    final response = await getLatLongFromAddressRemoteDataSource.getLatAndLong(
        address: address);

    response.fold(
      (Failure failure) => emit(
        const GetLatAndLongFailure(errorMessage: Labels.errorHappened),
      ),
      (data) async {
        type = data.type;
        fromEn = data.address;
        startLat = data.lat;
        startLong = data.lng;

        print("Response 1=============\n");
        print(type);
        print("Response 2=============\n");

        BlocProvider.of<DestGetLatAndLongCubit>(context).endLong ?? 0;
        if (isTripJoin == false &&
            BlocProvider.of<DestGetLatAndLongCubit>(context).endLat != null &&
            BlocProvider.of<DestGetLatAndLongCubit>(context).endLong != null) {
          await BlocProvider.of<GetPriceCarpoolCubit>(context).getPriceCarpool(
            getPriceCarpoolParam: GetPriceCarpoolParam(
              womenOnly: false,
              womenDriverOnly: false,
              comfort: false,
              startLocation: [startLat!, startLong!],
              targetLocation: [
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLat!,
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLong!
              ],
            ),
          );
        }
        if (isTripJoin == true &&
            BlocProvider.of<DestGetLatAndLongCubit>(context).endLat != null &&
            BlocProvider.of<DestGetLatAndLongCubit>(context).endLong != null) {
          await BlocProvider.of<FetchPriceDistanceCubit>(context)
              .fetchPriceDistance(
            destiantionLocation: LatLng(
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLat!,
                BlocProvider.of<DestGetLatAndLongCubit>(context).endLong!),
            startLocation: LatLng(startLat!, startLong!),
          );
        }

        emit(GetLatAndLongSuccess(latLongData: data));
        print("Response 3 =============\n");
      },
    );
  }
}
