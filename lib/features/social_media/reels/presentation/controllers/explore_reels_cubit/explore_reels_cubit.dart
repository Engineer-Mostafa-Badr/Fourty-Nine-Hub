import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/share_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/add_reel_reply_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/create_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/get_comments_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/get_explore_reels_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/get_followers_reels_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/like_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/reels_with_same_audia_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/save_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/share_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/toggle_comment_like_use_case.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/utils/shared_pref.dart';
import '../../../data/models/new_reels_model.dart';

part 'explore_reels_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final CreateReelUseCase _createReelUseCase;
  final CreateAdvertisementUseCase _advertisementUseCase;
  final GetExploreReelsUseCase _getExploreReelsUseCase;
  final GetFollowersReelsUseCase _getFollowersReelsUseCase;
  final SaveReelUseCase _saveReelUseCase;
  final ShareReelUseCase _shareReelUseCase;
  final LikeReelUseCase _likeReelUseCase;
  final AddReelCommentUseCase _addCommentUseCase;
  final AddReelReplyUseCase _addReplyUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final ToggleCommentLikeUseCase _toggleCommentLikeUseCase;
  final ReelsWithSameAudioUseCase _reelsWithSameAudioUseCase;
  ReelsCubit(
      this._createReelUseCase,
      this._advertisementUseCase,
      this._getExploreReelsUseCase,
      this._getFollowersReelsUseCase,
      this._saveReelUseCase,
      this._shareReelUseCase,
      this._likeReelUseCase,
      this._addCommentUseCase,
      this._addReplyUseCase,
      this._getCommentsUseCase,
      this._toggleCommentLikeUseCase,
      this._reelsWithSameAudioUseCase)
      : super(ReelsState());

//---------------------------------------------------------------------------------------

  var pauseChild = false;

  pauseChildVideo({bool pause = false}) {
    pauseChild = pause;
    print("${pauseChild}asfsldhfnsd");

    emit(state);
  }

  Future<void> createReelView(String reelId, int duration) async {
    emit(state.copyWith(isCreatingReelView: true));
    //
    // final String url = 'https://49dev.com/api/v1/reels/views/$reelId';
    //
    // final result = await apiConsumer.post(
    //   url,
    //   data: {
    //     "duration": duration,
    //   },
    // );
    final result = await _createReelUseCase(
      CreateReelParams(reelId: reelId, duration: duration),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) => emit(state.copyWith(reelViewSuccess: true)),
    );
  }

//---------------------------------------------------------------------------------------

  Future<void> uploadReel(
    File videoFile, {
    String? comeFrom,
    String? totalPrice,
    String? advertisementType,
  }) async {
    // Step 1: Generate Signed URL
    final token = await CacheManager.getAccessToken();
    final response = await http.post(
      Uri.parse(
          'https://49dev.com/api/v1/reels?subCategory=66684135dbb427ee42aa0141'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "subcategoryId": "66684135dbb427ee42aa0141",
        "isAudioOriginal": false,
        "metadata": {
          "name": videoFile.path.split('/').last,
          "size": videoFile.lengthSync(),
          "type": "video/mp4",
          "videoWidth": 640,
          // Adjust these values according to your video metadata
          "videoHeight": 360,
          "inputAudioId": "66ba3fb7baf9033183036cd0"
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      log("${responseData['data']['signedUrl']}1111111111111111111111111111111111111111111111111111111111111111111111");
      final signedUrl = responseData['data']['signedUrl'];

      // Step 2: Upload Video using the Signed URL
      final uploadResponse = await http.put(
        Uri.parse(signedUrl),
        headers: {
          'Content-Type': 'video/mp4',
        },
        body: videoFile.readAsBytesSync(),
      );

      if (uploadResponse.statusCode == 200) {
        log('Video uploaded successfully!>>>>${responseData['data']['mediaId']}/////////1111111111111111111111111111111111111111111111111111111111111111111111');
        if (comeFrom == 'company') {
          createAdvertisement([responseData['data']['mediaId']],
              advertisementType!, double.parse(totalPrice!));
        }
      } else {
        print('Failed to upload video: ${uploadResponse.statusCode}');
        print('Response body: ${uploadResponse.body}');
      }
    } else {
      print('Failed to generate signed URL: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

//---------------------------------------------------------------------------------------
  Future<void> createAdvertisement(
      List<String> mediaIds, String type, double totalPrice) async {
    final result = await _advertisementUseCase(
      CreateAdvertisementParams(
          type: type, mediaIds: mediaIds, totalPrice: totalPrice),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        print(
            'Advertisement created successfully!  $data ****************************************************');
      },
    );
    // final token = await CacheManager.getAccessToken();
    //
    // final url = Uri.parse('https://49dev.com/api/v1/advertisementCompany');
    // final headers = {
    //   'Authorization': 'Bearer $token',
    //   'Content-Type': 'application/json',
    // };
    // final body = jsonEncode({
    //   "advertisements": [
    //     {
    //       "media": mediaIds,
    //       "advertisement_type": type,
    //       "totalPrice": totalPrice,
    //     }
    //   ]
    // });
    //
    // try {
    //   final response = await http.post(
    //     url,
    //     headers: headers,
    //     body: body,
    //   );
    //
    //   if (response.statusCode == 200) {
    //     // Handle success
    //     print(
    //         'Advertisement created successfully!  ${response.body} ****************************************************');
    //   } else {
    //     // Handle failure
    //     print('Failed to create advertisement: ${response.body}');
    //     print('Response: ${response.body}');
    //   }
    // } catch (e) {
    //   // Handle error
    //   print('Error occurred: $e');
    // }
  }

//---------------------------------------------------------------------------------------
  Future<void> fetchReels() async {
    if ((state.globalReelsIsLoading ?? false) ||
        (state.globalReelsHasReachedMax ?? false)) return;

    emit(state.copyWith(isLoading: true));
    final result = await _getExploreReelsUseCase(1);

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        print("${data.data.reels.length}asfadjcbalc");
        emit(state.copyWith(
          reels: [...state.globalReels ?? [], ...data.data.reels],
          isLoading: false,
          hasReachedMax: data.data.pagination.currentPage >=
              data.data.pagination.pageCount,
          currentPage: data.data.pagination.currentPage,
        ));
      },
    );
    //
    // try {
    //   // Fetch 3 reels at a time
    //   final ReelsResponse response = await repository.fetchReels(
    //     page: (state.globalReelsCurrentPage??0) + 1,
    //   );
    //
    //   print("${response.data.reels.length}asfadjcbalc");
    //   emit(state.copyWith(
    //     reels: [...state.globalReels, ...response.data.reels],
    //     isLoading: false,
    //     hasReachedMax: response.data.pagination.currentPage >=
    //         response.data.pagination.pageCount,
    //     currentPage: response.data.pagination.currentPage,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(isLoading: false));
    // }
  }

//--------------------------------------------------------------------------------------------//---------------------------------------------------------------------------------------
  Future<void> fetchReelsForFollowers() async {
    // if (state.reelsForFollowerIsLoading ||
    //     state.reelsForFollowerHasReachedMax) {
    //   return;
    // }

    emit(state.copyWith(reelsForFollowerIsLoading: true));

    final result = await _getFollowersReelsUseCase(1);

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        print("${data.data.reels.length}asfadjcbalc");
        emit(state.copyWith(
          reelsForFollower: [
            ...state.reelsForFollower ?? [],
            ...data.data.reels
          ],
          reelsForFollowerIsLoading: false,
          reelsForFollowerHasReachedMax: data.data.pagination.currentPage >=
              data.data.pagination.pageCount,
          reelsForFollowerCurrentPage: data.data.pagination.currentPage,
        ));
      },
    );

    // try {
    //   // Fetch 3 reels at a time
    //   final ReelsResponse response = await repository.fetchReelsForFollowers(
    //     page: state.reelsForFollowerCurrentPage + 1,
    //   );
    //
    //   log('from fetchReelsForFollowers --> ${response.data.reels.length}');
    //   emit(state.copyWith(
    //     reelsForFollower: [...state.reelsForFollower, ...response.data.reels],
    //     reelsForFollowerIsLoading: false,
    //     reelsForFollowerHasReachedMax: response.data.pagination.currentPage >=
    //         response.data.pagination.pageCount,
    //     reelsForFollowerCurrentPage: response.data.pagination.currentPage,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(reelsForFollowerIsLoading: false));
    // }
  }

//--------------------------------------------------------------------------------------------
  // New method to save a reel
  Future<String?> saveReel(String reelId) async {
    final result = await _saveReelUseCase(reelId);
    String message = '';
    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        emit(state.copyWith(reelSaveResponse: data
            // Add any state update logic here if necessary
            ));
        message = data.message ?? '';
      },
    );
    return message;
    // try {
    //   // Optionally, you can emit a loading state here if you want to show a loader or disable UI interaction
    //   final ReelSaveResponse response = await repository.saveReel(reelId);
    //
    //   // Optionally, you can update the state to reflect that the reel was saved, or show a success message
    //
    //   log("Reel saved successfully ${response.message}------------------------------------------------------");
    //
    //   emit(state.copyWith(reelSaveResponse: response
    //       // Add any state update logic here if necessary
    //       ));
    //   return response.message;
    //   log("Reel saved successfully");
    // } catch (e) {
    //   log("Error saving reel: $e");
    //   // Optionally, emit a state with an error message if needed
    // }
    // return null;
  }

//--------------------------------------------------------------------------------------------
  // New method to share a reel
  Future<void> shareReel(String reelId) async {
    final result = await _shareReelUseCase(reelId);
    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        emit(state.copyWith(reelShareResponse: data
            // Add any state update logic here if necessary
            ));
      },
    );
    // try {
    //   // Optionally, you can emit a loading state here if you want to show a loader or disable UI interaction
    //   final ReelShareResponse response = await repository.shareReel(reelId);
    //
    //   // Optionally, you can update the state to reflect that the reel was shared, or show a success message
    //   emit(state.copyWith(reelShareResponse: response
    //       // Add any state update logic here if necessary
    //       ));
    //   log("Reel shared successfully");
    // } catch (e) {
    //   log("Error sharing reel: $e");
    //   // Optionally, emit a state with an error message if needed
    // }
  }

//--------------------------------------------------------------------------------------------
  Future<String> likeReel(String reelId) async {
    emit(state.copyWith(
        isLikingReel: false, likeReelErrorMessage: 'loadingLike'));
    final result = await _likeReelUseCase(reelId);
    String message = '';
    result.fold(
        (failure) => emit(state.copyWith(
            isLikingReel: false, likeReelErrorMessage: 'errorLike')), (data) {
      message = data.message;
      emit(state.copyWith(
          likeReelResponse: data,
          isLikingReel:
              data.message == "Reel liked successfully" ? true : false));
    });
    return message;
    // try {
    //   emit(state.copyWith(
    //       isLikingReel: false, likeReelErrorMessage: 'loadingLike'));
    //
    //   final response = await repository.likeReel(reelId);
    //
    //   print("${response.message}dsfdvsdvsdv");
    //   // Assuming you might want to update the specific reel in the list with the like status
    //   List<Reel> updatedReels = state.globalReels.map((reel) {
    //     if (reel.id == reelId) {
    //       // Update the reel here if needed
    //     }
    //     return reel;
    //   }).toList();
    //
    //   emit(state.copyWith(
    //       likeReelResponse: response,
    //       isLikingReel:
    //           response.message == "Reel liked successfully" ? true : false));
    //   return  response.message;
    // } catch (e) {
    //   emit(state.copyWith(
    //       isLikingReel: false,
    //       likeReelErrorMessage:
    //           'errorLike')); // Handle the error, possibly update the UI state or show an error message
    // }
    // return '';
  }

  //======================================================================================
  Future<void> addComment(String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    emit(state.copyWith(isCommenting: false));
    final result = await _addCommentUseCase(
        AddReelCommentParams(comment: comment, reelId: reelId));
    result.fold(
        (failure) => emit(state.copyWith(
              isCommenting: false,
              commentErrorMessage: "An error occurred while adding the comment",
            )), (data) {
      emit(state.copyWith(
        isCommenting: true,
        commentResponse: data,
        commentErrorMessage: data.status ? null : "Failed to add comment",
      ));
    });
    // try {
    //   // Indicate that a comment is being added
    //   emit(state.copyWith(isCommenting: false));
    //
    //   // Make the API call to add a comment
    //   final response = await repository.addComment(
    //     reelId: reelId,
    //     comment: comment,
    //   );
    //
    //   // Update the state based on the response
    //   log("${response.message}=====================================--------------------------------");
    //   emit(state.copyWith(
    //     isCommenting: true,
    //     commentResponse: response,
    //     commentErrorMessage: response.status ? null : "Failed to add comment",
    //   ));
    // } catch (e) {
    //   // Handle errors and update the state accordingly
    //   emit(state.copyWith(
    //     isCommenting: false,
    //     commentErrorMessage: "An error occurred while adding the comment",
    //   ));
    // }
  }

  Future<void> addReplayComment(String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    emit(state.copyWith(isCommenting: false));
    final result = await _addReplyUseCase(AddReelReplyParams(
        comment: comment,
        reelId: reelId,
        parentCommentId: parentCommentId,
        receiverComment: receiverComment));
    result.fold(
        (failure) => emit(state.copyWith(
              isCommenting: false,
              commentErrorMessage: "An error occurred while adding the comment",
            )), (data) {
      emit(state.copyWith(
        isCommenting: true,
        commentResponse: data,
        commentErrorMessage: data.status ? null : "Failed to add comment",
      ));
    });
    // try {
    //   // Indicate that a comment is being added
    //   emit(state.copyWith(isCommenting: false));
    //
    //   // Make the API call to add a comment
    //   final response = await repository.addReplayComment(
    //     reelId: reelId,
    //     comment: comment,
    //     receiverComment: receiverComment,
    //     parentCommentId: parentCommentId,
    //   );
    //
    //   // Update the state based on the response
    //   log("${response.message}=====================================--------------------------------");
    //   emit(state.copyWith(
    //     isCommenting: true,
    //     commentResponse: response,
    //     commentErrorMessage: response.status ? null : "Failed to add comment",
    //   ));
    // } catch (e) {
    //   // Handle errors and update the state accordingly
    //   emit(state.copyWith(
    //     isCommenting: false,
    //     commentErrorMessage: "An error occurred while adding the comment",
    //   ));
    // }
  }

  Future<void> getComments(String reelId) async {
    final result = await _getCommentsUseCase(reelId);
    result.fold(
        (failure) => emit(state.copyWith(
            isFetchingComments: false,
            fetchCommentsErrorMessage: 'fetchCommentsError')), (data) {
      emit(state.copyWith(isFetchingComments: true, fetchedComments: data));
    });
    // try {
    //   emit(state.copyWith(isFetchingComments: false));
    //   final commentsResponse = await repository.fetchComments(reelId);
    //   log("${commentsResponse.data.first.comment}aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    //   emit(state.copyWith(
    //       isFetchingComments: true, fetchedComments: commentsResponse));
    // } catch (e) {
    //   emit(state.copyWith(
    //       isFetchingComments: false,
    //       fetchCommentsErrorMessage: 'fetchCommentsError'));
    // }
  }

  Future<void> toggleCommentLike(String commentId) async {
    final result = await _toggleCommentLikeUseCase(commentId);
    result.fold(
        (failure) => emit(state.copyWith(
            isLikingComment: false,
            likeReelErrorMessage:
                'An error occurred while liking/unliking the comment')),
        (data) {
      emit(state.copyWith(
        likeReelCommentResponseMessage: data,
      )); // Save the message ("like" or "unlike")
    });
    // try {
    //   emit(state.copyWith(isLikingComment: true));
    //
    //   final message = await repository.toggleLike(commentId);
    //
    //   if (message != null) {
    //     emit(state.copyWith(
    //       likeReelCommentResponseMessage: message,
    //     )); // Save the message ("like" or "unlike")
    //   }
    // } catch (e) {
    //   emit(state.copyWith(
    //       isLikingComment: false,
    //       likeReelErrorMessage:
    //           'An error occurred while liking/unliking the comment'));
    // }
    // _reelsWithSameAudioUseCase
  }

  Future<void> fetchReelsWithSameAudio(String audioId,
      {bool isInitialLoad = false}) async {
    if ((state.globalReelsIsLoading ?? false) ||
        (state.globalReelsHasReachedMax ?? false)) return;

    emit(state.copyWith(isLoading: true));
    final int pageToFetch =
        isInitialLoad ? 1 : (state.globalReelsCurrentPage ?? 0) + 1;
    final result = await _reelsWithSameAudioUseCase(
        ReelsWithSameAudioParams(audioId: audioId));
    result.fold((failure) => emit(state.copyWith(isLoading: false)), (data) {
      final bool hasReachedMax =
          pageToFetch >= data.data!.pagination!.pageCount!;
      final List<Reel> newReels = data.data?.reels ?? [];
      log("${newReels.first.user.firstName}----------------------------------------------------------------------------------------------");

      emit(state.copyWith(
        reelsForAudio:
            isInitialLoad ? newReels : [...?state.reelsForAudio, ...newReels],
        isLoading: false,
        hasReachedMax: hasReachedMax,
        currentPage: pageToFetch,
      ));
    });

    // try {
    //   // If it's an initial load, start from the first page
    //   final int pageToFetch =
    //       isInitialLoad ? 1 : state.globalReelsCurrentPage + 1;
    //
    //   final ReelsForAudioResponse response =
    //       await repository.fetchReelsWithSameAudio(audioId, page: pageToFetch);
    //
    //   final bool hasReachedMax =
    //       pageToFetch >= response.data!.pagination!.pageCount!;
    //
    //   final List<Reel> newReels = response.data?.reels ?? [];
    //   log("${newReels.first.user.firstName}----------------------------------------------------------------------------------------------");
    //
    //   emit(state.copyWith(
    //     reelsForAudio:
    //         isInitialLoad ? newReels : [...?state.reelsForAudio, ...newReels],
    //     isLoading: false,
    //     hasReachedMax: hasReachedMax,
    //     currentPage: pageToFetch,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(isLoading: false));
    //   log("Error fetching reels with the same audio: $e");
    // }
  }

  void updatePlayingIndex(int? index) {
    emit(state.copyWith(playingIndex: index));
  }
}
