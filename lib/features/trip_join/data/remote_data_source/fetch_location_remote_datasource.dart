// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/trip_join/domain/entities/location_entity.dart';

abstract class FetchLocationRemoteDataSource {
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations({required String address});
}

class FetchLocationRemoteDataSourceImp implements FetchLocationRemoteDataSource {
  final ApiConsumer apiConsumer;
  FetchLocationRemoteDataSourceImp({
    required this.apiConsumer,
  });
  @override
  Future<Either<Failure, LocationEntity>> fetchLocationCordinations({required String address}) {
    // TODO: implement createDoctor
    throw UnimplementedError();
  }
}
