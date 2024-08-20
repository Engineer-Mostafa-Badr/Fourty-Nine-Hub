// import 'package:dartz/dartz.dart';
//
// import '../../../../../core/error/failure.dart';
// import '../../domain/entities/reel_entity.dart';
// import '../../domain/repositories/reels_repository.dart';
// import '../data_sources/reels_remote_data_source.dart';
//
// class ReelsRepositoryImpl extends ReelsRepository {
//   final ReelsRemoteDataSource _reelsRemoteDataSource;
//
//   ReelsRepositoryImpl(this._reelsRemoteDataSource);
//
//   @override
//   Future<Either<Failure, List<ReelEntity>>> getExploreReels(int page) {
//     return _reelsRemoteDataSource.getExploreReels(page);
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;
import '../models/new_reels_model.dart';

class ReelsRepository {
  final String baseUrl = 'https://49dev.com/api/v1';

  // final String token =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjI1MjMwYjNmLWRiNmMtNDc0ZC1iOGMyLTM2OGU4YzI4NGEyYyIsImlhdCI6MTcyMzgzODkyMywiZXhwIjo1NTcyMzgzODkyMywic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.t99anZes1_ff-X2Y-avdzViB1Imm_1p_K7aMoP34PKk";

  final String token = serviceLocator<UserCubit>().token ?? '';

  Future<ReelsResponse> fetchReels({int page = 1, int limit = 3}) async {
    log(token + "78888888888888888888");
    final response = await http.get(
      Uri.parse('$baseUrl/reels/explore?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      log("from ReelsRepository");
      return ReelsResponse.fromJson(json.decode(response.body));
    } else {
      log("from ReelsRepository Failed to load reels--------------");

      throw Exception('Failed to load reels');
    }
  }
}
