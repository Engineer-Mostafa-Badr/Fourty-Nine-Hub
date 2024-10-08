import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/repositories/reider_request_repository.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class GetRouteRiderCubit extends Cubit<RiderState> {
  final ReiderRequestRepository repository;
  GetRouteRiderCubit({required this.repository}) : super(RiderInitial());
  Future<List<LatLng>> getRoute({required LatLng start, required LatLng end}) {
    return repository.getRoute(start: start, end: end);
  }
}
