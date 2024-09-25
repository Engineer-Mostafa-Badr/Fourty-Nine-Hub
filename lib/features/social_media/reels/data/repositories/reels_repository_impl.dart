// // import 'package:dartz/dartz.dart';
// //
// // import '../../../../../core/error/failure.dart';
// // import '../../domain/entities/reel_entity.dart';
// // import '../../domain/repositories/reels_repository.dart';
// // import '../data_sources/reels_remote_data_source.dart';
// //
// // class ReelsRepositoryImpl extends ReelsRepository {
// //   final ReelsRemoteDataSource _reelsRemoteDataSource;
// //
// //   ReelsRepositoryImpl(this._reelsRemoteDataSource);
// //
// //   @override
// //   Future<Either<Failure, List<ReelEntity>>> getExploreReels(int page) {
// //     return _reelsRemoteDataSource.getExploreReels(page);
// //   }
// // }
// import 'dart:convert';
// import 'dart:developer';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
// import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:http/http.dart' as http;
// import '../models/new_reels_model.dart';
//
// class ReelsRepository {
//   // final String token =
//   //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjI1MjMwYjNmLWRiNmMtNDc0ZC1iOGMyLTM2OGU4YzI4NGEyYyIsImlhdCI6MTcyMzgzODkyMywiZXhwIjo1NTcyMzgzODkyMywic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.t99anZes1_ff-X2Y-avdzViB1Imm_1p_K7aMoP34PKk";
//
//   final String token = serviceLocator<UserCubit>().token ?? '';
//
//   Future<ReelsResponse> fetchReels({int page = 1, int limit = 3}) async {
//     log(token + "78888888888888888888");
//     final response = await http.get(
//       Uri.parse(
//           'https://49dev.com/api/v1/reels/explore?page=$page&limit=$limit'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       log("from ReelsRepository");
//       return ReelsResponse.fromJson(json.decode(response.body));
//     } else {
//       log("from ReelsRepository Failed to load reels--------------");
//
//       throw Exception('Failed to load reels');
//     }
//   }
//
//   Future<ReelLikeResponse> likeReel(String reelId) async {
//     final String url = 'https://49dev.com/api/v1/reels/likes/$reelId';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         log("from likeReel repo${response.body}");
//         final responseBody = jsonDecode(response.body);
//         return ReelLikeResponse.fromJson(responseBody);
//         // Success
//       } else {
//         // Handle other status codes
//         throw Exception('Failed to like the reel');
//       }
//     } catch (e) {
//       // Handle error
//       throw Exception('Error liking the reel: $e');
//     }
//   }
//
//   Future<AddCommentResponse> addComment({
//     required String reelId,
//     required String comment,
//   }) async {
//     final String url = 'https://49dev.com/api/v1/reels/comments/$reelId';
//
//     try {
//       // Prepare the request body
//       final Map<String, dynamic> body = {
//         'comment': comment,
//       };
//
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(body),
//       );
//
//       // log("from addComment repo ${response.body}=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------");
//
//       // Handle the response
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         // log("from addComment repo ${response.body}=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------=====================----------------------");
//         final responseBody = jsonDecode(response.body);
//         return AddCommentResponse.fromJson(responseBody);
//       } else {
//         // Handle other status codes
//         throw Exception('Failed to add comment');
//       }
//     } catch (e) {
//       // Handle error
//       throw Exception('Error adding comment: $e');
//     }
//   }
//
//   Future<GetCommentsResponse> fetchComments(String reelId) async {
//     final response = await http.get(
//       Uri.parse('https://49dev.com/api/v1/reels/comments/$reelId'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       final data = json.decode(response.body);
//       log("${data}pppppppppppppppppppppppppppppppppppppppp");
//       return GetCommentsResponse.fromJson(data);
//     } else {
//       throw Exception('Failed to load comments');
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/audio_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../models/new_reels_model.dart';
import '../models/share_reel_model.dart';

class ReelsRepository {
  String? token;

  ReelsRepository() {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    token = await TokenManager.getAccessToken();
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await TokenManager.getAccessToken();
  }

  Future<http.Response?> _makeGetRequest({
    required String url,
    required String fromMethod,
  }) async {
    await _ensureTokenInitialized();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      log("from ReelsRepository");
      if (responseData['endPointSubscription'] != null &&
          responseData['endPointSubscription'] == true &&
          responseData['userSubscription'] == false) {
        List<WalletTypes> wallets = (responseData['paymentMethod'] as List)
            .map((e) => (e as String).toWalletType)
            .toList();
        await serviceLocator<SubscriptionController>().showSubscriptionPlans(
            subCategoryId: responseData['subCategoryId'], wallets: wallets);
      }
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        log("Failed to load data from -----$fromMethod -------------: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log("Error fetching data: $e");
    }
    return null;
  }

  Future<http.Response?> _makePostRequest({
    required String url,
    required String body,
  }) async {
    await _ensureTokenInitialized();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        log("Failed to post data: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      log("Error posting data: $e");
    }
    return null;
  }

  // New method to share a reel
  Future<ReelShareResponse> shareReel(String reelId) async {
    final String url = 'https://49dev.com/api/v1/reels/share/$reelId';

    final response = await _makePostRequest(url: url, body: '{}');
    if (response != null) {
      log("Reel shared successfully: ${response.body}");
      return ReelShareResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to share the reel');
    }
  }

  // New method to save a reel
  Future<ReelSaveResponse> saveReel(String reelId) async {
    final String url = 'https://49dev.com/api/v1/reels/saved/$reelId';

    final response = await _makePostRequest(url: url, body: '{}');
    if (response != null) {
      log("Reel saved successfully: ${response.body}");
      return ReelSaveResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to save the reel');
    }
  }

  Future<ReelsResponse> fetchReels({int page = 1, int limit = 3}) async {
    final url =
        'https://49dev.com/api/v1/reels/explore?page=$page&limit=$limit&subCategory=66684135dbb427ee42aa0141';
    final response = await _makeGetRequest(url: url, fromMethod: 'fetchReels');
    if (response != null) {
      var responseData = json.decode(response.body);
      log("from ReelsRepository");

      return ReelsResponse.fromJson(responseData);
    } else {
      log("from ReelsRepository Failed to load reels--------------");
      throw Exception('Failed to load reels');
    }
  }

  Future<ReelsResponse> fetchReelsForFollowers(
      {int page = 1, int limit = 3}) async {
    final url =
        'https://49dev.com/api/v1/reels/followers?page=$page&limit=$limit&subCategory=66684135dbb427ee42aa0141';
    final response = await _makeGetRequest(url: url, fromMethod: 'fetchReels');
    if (response != null) {
      log("from ReelsRepository");
      return ReelsResponse.fromJson(json.decode(response.body));
    } else {
      log("from ReelsRepository Failed to load reels--------------");
      throw Exception('Failed to load reels');
    }
  }

  Future<ReelLikeResponse> likeReel(String reelId) async {
    final String url = 'https://49dev.com/api/v1/reels/likes/$reelId';

    final response = await _makePostRequest(url: url, body: '{}');
    if (response != null) {
      log("from likeReel repo${response.body}");
      return ReelLikeResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to like the reel');
    }
  }

  Future<AddCommentResponse> addComment({
    required String reelId,
    required String comment,
  }) async {
    final String url = 'https://49dev.com/api/v1/reels/comments/$reelId';

    final response = await _makePostRequest(
      url: url,
      body: jsonEncode({'comment': comment}),
    );

    if (response != null) {
      return AddCommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add comment');
    }
  }

  Future<AddCommentResponse> addReplayComment({
    required String reelId,
    required String comment,
    String? receiverComment,
    String? parentCommentId,
  }) async {
    final String url = 'https://49dev.com/api/v1/reels/comments/$reelId';

    final Map<String, dynamic> requestBody = {
      'comment': comment,
    };

    if (receiverComment != null) {
      requestBody['receiverComment'] = receiverComment;
    }

    if (parentCommentId != null) {
      requestBody['parentCommentId'] = parentCommentId;
    }

    final response = await _makePostRequest(
      url: url,
      body: jsonEncode(requestBody),
    );

    if (response != null) {
      return AddCommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add comment');
    }
  }

  Future<GetCommentsResponse> fetchComments(String reelId) async {
    final url = 'https://49dev.com/api/v1/reels/comments/$reelId';

    final response =
        await _makeGetRequest(url: url, fromMethod: 'fetchComments');
    if (response != null) {
      log("${response.body} from fetchComments repo *******************************************************************");
      return GetCommentsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<String?> toggleLike(String commentId) async {
    final String url =
        'https://49dev.com/api/v1/reels/comments/like/$commentId';

    final response = await _makePostRequest(url: url, body: '{}');
    if (response != null) {
      final parsedResponse = jsonDecode(response.body);

      log("from toggleLike repo: ${parsedResponse['message']}");

      return parsedResponse['message']; // "like" or "unlike"
    } else {
      throw Exception('Failed to like/unlike the comment');
    }
  }

  Future<ReelsForAudioResponse> fetchReelsWithSameAudio(String audioId,
      {int page = 1, int limit = 10}) async {
    final url = 'https://49dev.com/api/v1/reels/audio/$audioId';
    // 'https://49dev.com/api/v1/reels/audio/$audioId?page=$page&limit=$limit';

    final response =
        await _makeGetRequest(url: url, fromMethod: 'fetchReelsWithSameAudio');
    if (response != null) {
      log("Fetched reels with the same audio successfully.");
      return ReelsForAudioResponse.fromJson(json.decode(response.body));
    } else {
      log("Failed to fetch reels with the same audio.");
      throw Exception('Failed to fetch reels with the same audio');
    }
  }
}
