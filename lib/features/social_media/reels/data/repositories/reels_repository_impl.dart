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
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;
import '../models/new_reels_model.dart';

class ReelsRepository {
  // final String token =
  //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjI1MjMwYjNmLWRiNmMtNDc0ZC1iOGMyLTM2OGU4YzI4NGEyYyIsImlhdCI6MTcyMzgzODkyMywiZXhwIjo1NTcyMzgzODkyMywic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.t99anZes1_ff-X2Y-avdzViB1Imm_1p_K7aMoP34PKk";

  final String token = serviceLocator<UserCubit>().token ?? '';

  Future<ReelsResponse> fetchReels({int page = 1, int limit = 3}) async {
    log(token + "78888888888888888888");
    final response = await http.get(
      Uri.parse(
          'https://49dev.com/api/v1/reels/explore?page=$page&limit=$limit'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      log("from ReelsRepository");
      return ReelsResponse.fromJson(json.decode(response.body));
    } else {
      log("from ReelsRepository Failed to load reels--------------");

      throw Exception('Failed to load reels');
    }
  }

  Future<ReelLikeResponse> likeReel(String reelId) async {
    final String url = 'https://49dev.com/api/v1/reels/likes/$reelId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        log("from likeReel repo${response.body}");
        final responseBody = jsonDecode(response.body);
        return ReelLikeResponse.fromJson(responseBody);
        // Success
      } else {
        // Handle other status codes
        throw Exception('Failed to like the reel');
      }
    } catch (e) {
      // Handle error
      throw Exception('Error liking the reel: $e');
    }
  }

  Future<AddCommentResponse> addComment({
    required String reelId,
    required String comment,
  }) async {
    final String url = 'https://49dev.com/api/v1/reels/comments/$reelId';

    try {
      // Prepare the request body
      final Map<String, dynamic> body = {
        'comment': comment,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // log("from addComment repo ${response.body}=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------");

      // Handle the response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // log("from addComment repo ${response.body}=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------");
        final responseBody = jsonDecode(response.body);
        return AddCommentResponse.fromJson(responseBody);
      } else {
        // Handle other status codes
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      // Handle error
      throw Exception('Error adding comment: $e');
    }
  }

  Future<GetCommentsResponse> fetchComments(String reelId) async {
    final response = await http.get(
      Uri.parse('https://49dev.com/api/v1/reels/comments/$reelId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      log("${data}pppppppppppppppppppppppppppppppppppppppp");
      return GetCommentsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
