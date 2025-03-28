import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/data_source/get_lat_long_from_address_remote_data_source.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/data/models/get_lat_and_long_model.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/get_price_carpool_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_price_carpool/get_price_carpool_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_price_distance/fetch_price_distance_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this import

part 'dest_get_lat_and_long_state.dart';

class DestGetLatAndLongCubit extends Cubit<DestGetLatAndLongState> {
  final GetLatLongFromAddressRemoteDataSource
      getLatLongFromAddressRemoteDataSource;

  String type = '';
  double? endLat;
  double? endLong;
  String toEn = '';
  DestGetLatAndLongCubit({required this.getLatLongFromAddressRemoteDataSource})
      : super(DestGetLatAndLongInitial());

  Future<void> getLatAndLong(
      {required BuildContext context, // Corrected here
      required String address,
      bool isTripJoin = false,
      required bool isStart}) async {
    emit(DestGetLatAndLongLoading());
    final response = await getLatLongFromAddressRemoteDataSource.getLatAndLong(
        address: address);

    response.fold(
      (Failure failure) => emit(
        const DestGetLatAndLongFailure(errorMessage: Labels.errorHappened),
      ),
      (data) async {
        type = data.type;

        endLat = data.lat;
        endLong = data.lng;
        toEn = data.address;

        print("Response 1=============\n");
        print(type);
        print("Response 2=============\n");
        if (isTripJoin == false &&
            BlocProvider.of<GetLatAndLongCubit>(context).startLat != null &&
            BlocProvider.of<GetLatAndLongCubit>(context).startLong != null) {
          await BlocProvider.of<GetPriceCarpoolCubit>(context).getPriceCarpool(
            getPriceCarpoolParam: GetPriceCarpoolParam(
              womenOnly: false,
              womenDriverOnly: false,
              comfort: false,
              startLocation: [
                BlocProvider.of<GetLatAndLongCubit>(context).startLat!,
                BlocProvider.of<GetLatAndLongCubit>(context).startLong!
              ],
              targetLocation: [endLat!, endLong!],
            ),
          );
        }
        if (isTripJoin == true &&
            BlocProvider.of<GetLatAndLongCubit>(context).startLat != null &&
            BlocProvider.of<GetLatAndLongCubit>(context).startLong != null) {
          await BlocProvider.of<FetchPriceDistanceCubit>(context)
              .fetchPriceDistance(
            destiantionLocation: LatLng(endLat!, endLong!),
            startLocation: LatLng(
                BlocProvider.of<GetLatAndLongCubit>(context).startLat!,
                BlocProvider.of<GetLatAndLongCubit>(context).startLong!),
          );
        }
        print("Response 33=============\n");

        emit(DestGetLatAndLongSuccess(latLongData: data));
        print("Response 33=============\n");
      },
    );
  }
}
