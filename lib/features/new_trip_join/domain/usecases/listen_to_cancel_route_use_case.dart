import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_auto_accept_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/trip_repository.dart';

class ListenToCancelRouteUseCase
    extends NormalUseCase<void, Function(ListenToCancelRouteParams params)> {
  final TripRepository _repo;
  ListenToCancelRouteUseCase(this._repo);

  @override
  void call(Function(ListenToCancelRouteParams params) params) {
    return _repo.listenToCancelRoute(params);
  }
}

class ListenToCancelRouteParams {
  final String routeId;
  final String creatorId;

  ListenToCancelRouteParams({required this.routeId, required this.creatorId});

  //fromJson
  factory ListenToCancelRouteParams.fromJson(Map<String, dynamic> json) {
    return ListenToCancelRouteParams(routeId: json['id'], creatorId: json['creatorUserId']);
  }
}