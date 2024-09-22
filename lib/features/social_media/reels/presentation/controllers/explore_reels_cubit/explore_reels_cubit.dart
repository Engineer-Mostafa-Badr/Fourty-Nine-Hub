// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'package:fourtyninehub/core/states/basic_state.dart';
// import 'package:fourtyninehub/features/social_media/reels/domain/entities/reel_entity.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// import '../../../domain/use_case/get_explore_reels_use_case.dart';
//
// class ExploreReelsCubit extends Cubit<BasicState> {
//   final GetExploreReelsUseCase _getExploreReelsUseCase;
//   late final PagingController<int, ReelEntity> exploreReelsPagingController =
//       PagingController(firstPageKey: 1)
//         ..addPageRequestListener(_getExploreReels);
//
//   ExploreReelsCubit(this._getExploreReelsUseCase) : super(const BasicState());
//
//   Future<void> _getExploreReels(int page) async {
//     final result = await _getExploreReelsUseCase(page);
//     result.fold(
//       (failure) {
//         exploreReelsPagingController.error = failure;
//       },
//       (reels) {
//         if (reels.length < EndPoints.pageSize) {
//           exploreReelsPagingController.appendLastPage(reels);
//         } else {
//           exploreReelsPagingController.appendPage(reels, page + 1);
//         }
//       },
//     );
//   }
//
//   @override
//   Future<void> close() {
//     exploreReelsPagingController.dispose();
//     return super.close();
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/add_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/audio_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/get_comments_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/like_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/save_reel_model.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/share_reel_model.dart';
import 'package:http/http.dart' as http;

import '../../../../../../core/utils/shared_pref.dart';
import '../../../data/models/new_reels_model.dart';
import '../../../data/repositories/reels_repository_impl.dart';

class ReelsState {
  final List<Reel> globalReels;

  final List<Reel> reelsForFollower;

  final List<Reel>? reelsForAudio;
  final int? playingIndex;

  final bool globalReelsIsLoading;
  final bool globalReelsHasReachedMax;
  final int globalReelsCurrentPage;

  final bool reelsForFollowerIsLoading;
  final bool reelsForFollowerHasReachedMax;
  final int reelsForFollowerCurrentPage;

  final bool isLikingComment;
  final String likeReelCommentErrorMessage;
  final String likeReelCommentResponseMessage;

  // Fields related to liking a reel
  final bool isLikingReel;
  final String? likeReelErrorMessage;
  final ReelLikeResponse? likeReelResponse;

  final ReelSaveResponse? reelSaveResponse;
  final ReelShareResponse reelShareResponse;

  // New fields related to adding a comment
  final bool isCommenting;
  final String? commentErrorMessage;
  final AddCommentResponse? commentResponse;

  // Fields related to fetching comments
  final bool isFetchingComments;
  final String? fetchCommentsErrorMessage;
  final GetCommentsResponse? fetchedComments;

  // New fields related to replaying a comment
  final bool isReplyingComment;
  final String? replyCommentErrorMessage;
  final AddCommentResponse? replyCommentResponse;

  // Fields related to uploading a reel
  final bool isUploadingReel;
  final String? uploadReelErrorMessage;
  final bool? uploadReelSuccess;

  ReelsState({
    required this.reelsForFollower,
    this.reelsForFollowerIsLoading = false,
    this.reelsForFollowerHasReachedMax = false,
    this.reelsForFollowerCurrentPage = 0,
    this.reelsForAudio,
    this.isLikingComment = false,
    this.likeReelCommentErrorMessage = '',
    this.likeReelCommentResponseMessage = '',
    required this.reelSaveResponse,
    required this.reelShareResponse,
    required this.globalReels,
    required this.globalReelsIsLoading,
    this.playingIndex,
    required this.globalReelsHasReachedMax,
    required this.globalReelsCurrentPage,
    this.isLikingReel = false,
    this.likeReelErrorMessage,
    this.likeReelResponse,
    this.isCommenting = false,
    this.commentErrorMessage,
    this.commentResponse,
    this.isFetchingComments = false,
    this.fetchCommentsErrorMessage,
    this.fetchedComments,
    this.isReplyingComment = false,
    this.replyCommentErrorMessage,
    this.replyCommentResponse,
    this.isUploadingReel = false,
    this.uploadReelErrorMessage,
    this.uploadReelSuccess,
  });

  ReelsState copyWith({
    List<Reel>? reelsForFollower,
    bool? reelsForFollowerIsLoading,
    bool? reelsForFollowerHasReachedMax,
    int? reelsForFollowerCurrentPage,
    int? playingIndex,
    bool? isLikingComment,
    String? likeReelCommentErrorMessage,
    String? likeReelCommentResponseMessage,
    ReelSaveResponse? reelSaveResponse,
    ReelShareResponse? reelShareResponse,
    List<Reel>? reels,
    List<Reel>? reelsForAudio,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLikingReel,
    String? likeReelErrorMessage,
    ReelLikeResponse? likeReelResponse,
    bool? isCommenting,
    String? commentErrorMessage,
    AddCommentResponse? commentResponse,
    bool? isFetchingComments,
    String? fetchCommentsErrorMessage,
    GetCommentsResponse? fetchedComments,
    bool? isReplyingComment,
    String? replyCommentErrorMessage,
    AddCommentResponse? replyCommentResponse,
    bool? isUploadingReel,
    String? uploadReelErrorMessage,
    bool? uploadReelSuccess,
  }) {
    return ReelsState(
        isLikingComment: isLikingComment ?? this.isLikingComment,
        likeReelCommentErrorMessage:
            likeReelCommentErrorMessage ?? this.likeReelCommentErrorMessage,
        likeReelCommentResponseMessage: likeReelCommentResponseMessage ??
            this.likeReelCommentResponseMessage,
        globalReels: reels ?? this.globalReels,
        reelsForAudio: reelsForAudio ?? this.reelsForAudio,
        globalReelsIsLoading: isLoading ?? this.globalReelsIsLoading,
        globalReelsHasReachedMax:
            hasReachedMax ?? this.globalReelsHasReachedMax,
        globalReelsCurrentPage: currentPage ?? this.globalReelsCurrentPage,
        isLikingReel: isLikingReel ?? this.isLikingReel,
        likeReelErrorMessage: likeReelErrorMessage ?? this.likeReelErrorMessage,
        likeReelResponse: likeReelResponse ?? this.likeReelResponse,
        isCommenting: isCommenting ?? this.isCommenting,
        commentErrorMessage: commentErrorMessage ?? this.commentErrorMessage,
        commentResponse: commentResponse ?? this.commentResponse,
        isFetchingComments: isFetchingComments ?? this.isFetchingComments,
        fetchCommentsErrorMessage:
            fetchCommentsErrorMessage ?? this.fetchCommentsErrorMessage,
        fetchedComments: fetchedComments ?? this.fetchedComments,
        isReplyingComment: isReplyingComment ?? this.isReplyingComment,
        replyCommentErrorMessage:
            replyCommentErrorMessage ?? this.replyCommentErrorMessage,
        replyCommentResponse: replyCommentResponse ?? this.replyCommentResponse,
        isUploadingReel: isUploadingReel ?? this.isUploadingReel,
        uploadReelErrorMessage:
            uploadReelErrorMessage ?? this.uploadReelErrorMessage,
        uploadReelSuccess: uploadReelSuccess ?? this.uploadReelSuccess,
        reelSaveResponse: reelSaveResponse ?? this.reelSaveResponse,
        reelShareResponse: reelShareResponse ?? this.reelShareResponse,
        playingIndex: playingIndex ?? this.playingIndex,
        reelsForFollower: reelsForFollower ?? this.reelsForFollower,
        reelsForFollowerCurrentPage:
            reelsForFollowerCurrentPage ?? this.reelsForFollowerCurrentPage,
        reelsForFollowerHasReachedMax:
            reelsForFollowerHasReachedMax ?? this.reelsForFollowerHasReachedMax,
        reelsForFollowerIsLoading:
            reelsForFollowerIsLoading ?? this.reelsForFollowerIsLoading);
  }
}

class ReelsCubit extends Cubit<ReelsState> {
  final ReelsRepository repository;

  ReelsCubit({required this.repository})
      : super(ReelsState(
            reelsForFollower: [],
            reelSaveResponse: ReelSaveResponse(),
            reelShareResponse: ReelShareResponse(),
            globalReels: [],
            globalReelsIsLoading: false,
            globalReelsHasReachedMax: false,
            globalReelsCurrentPage: 0));

//---------------------------------------------------------------------------------------

  Future<void> uploadReel(
    File videoFile, {
    String? comeFrom,
    String? totalPrice,
    String? advertisementType,
  }) async {
    // Step 1: Generate Signed URL
    final token = await TokenManager.getAccessToken();
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
    final token = await TokenManager.getAccessToken();

    final url = Uri.parse('https://49dev.com/api/v1/advertisementCompany');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      "advertisements": [
        {
          "media": mediaIds,
          "advertisement_type": type,
          "totalPrice": totalPrice,
        }
      ]
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Handle success
        print(
            'Advertisement created successfully!  ${response.body} ****************************************************');
      } else {
        // Handle failure
        print('Failed to create advertisement: ${response.body}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle error
      print('Error occurred: $e');
    }
  }

//---------------------------------------------------------------------------------------
  Future<void> fetchReels() async {
    if (state.globalReelsIsLoading || state.globalReelsHasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    try {
      // Fetch 3 reels at a time
      final ReelsResponse response = await repository.fetchReels(
        page: state.globalReelsCurrentPage + 1,
      );

      emit(state.copyWith(
        reels: [...state.globalReels, ...response.data.reels],
        isLoading: false,
        hasReachedMax: response.data.pagination.currentPage >=
            response.data.pagination.pageCount,
        currentPage: response.data.pagination.currentPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

//--------------------------------------------------------------------------------------------//---------------------------------------------------------------------------------------
  Future<void> fetchReelsForFollowers() async {
    // if (state.reelsForFollowerIsLoading ||
    //     state.reelsForFollowerHasReachedMax) {
    //   return;
    // }

    emit(state.copyWith(reelsForFollowerIsLoading: true));

    try {
      // Fetch 3 reels at a time
      final ReelsResponse response = await repository.fetchReelsForFollowers(
        page: state.reelsForFollowerCurrentPage + 1,
      );

      log('from fetchReelsForFollowers --> ${response.data.reels.length}');
      emit(state.copyWith(
        reelsForFollower: [...state.reelsForFollower, ...response.data.reels],
        reelsForFollowerIsLoading: false,
        reelsForFollowerHasReachedMax: response.data.pagination.currentPage >=
            response.data.pagination.pageCount,
        reelsForFollowerCurrentPage: response.data.pagination.currentPage,
      ));
    } catch (e) {
      emit(state.copyWith(reelsForFollowerIsLoading: false));
    }
  }

//--------------------------------------------------------------------------------------------
  // New method to save a reel
  Future<String?> saveReel(String reelId) async {
    try {
      // Optionally, you can emit a loading state here if you want to show a loader or disable UI interaction
      final ReelSaveResponse response = await repository.saveReel(reelId);

      // Optionally, you can update the state to reflect that the reel was saved, or show a success message

      log("Reel saved successfully ${response.message}------------------------------------------------------");

      emit(state.copyWith(reelSaveResponse: response
          // Add any state update logic here if necessary
          ));
      return response.message;
      log("Reel saved successfully");
    } catch (e) {
      log("Error saving reel: $e");
      // Optionally, emit a state with an error message if needed
    }
    return null;
  }

//--------------------------------------------------------------------------------------------
  // New method to share a reel
  Future<void> shareReel(String reelId) async {
    try {
      // Optionally, you can emit a loading state here if you want to show a loader or disable UI interaction
      final ReelShareResponse response = await repository.shareReel(reelId);

      // Optionally, you can update the state to reflect that the reel was shared, or show a success message
      emit(state.copyWith(reelShareResponse: response
          // Add any state update logic here if necessary
          ));
      log("Reel shared successfully");
    } catch (e) {
      log("Error sharing reel: $e");
      // Optionally, emit a state with an error message if needed
    }
  }

//--------------------------------------------------------------------------------------------
  Future<void> likeReel(String reelId) async {
    try {
      emit(state.copyWith(
          isLikingReel: false, likeReelErrorMessage: 'loadingLike'));

      final response = await repository.likeReel(reelId);

      // Assuming you might want to update the specific reel in the list with the like status
      List<Reel> updatedReels = state.globalReels.map((reel) {
        if (reel.id == reelId) {
          // Update the reel here if needed
        }
        return reel;
      }).toList();

      emit(state.copyWith(
          likeReelResponse: response,
          isLikingReel:
              response.message == "Reel liked successfully" ? true : false));
    } catch (e) {
      emit(state.copyWith(
          isLikingReel: false,
          likeReelErrorMessage:
              'errorLike')); // Handle the error, possibly update the UI state or show an error message
    }
  }

  //======================================================================================
  Future<void> addComment(String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    try {
      // Indicate that a comment is being added
      emit(state.copyWith(isCommenting: false));

      // Make the API call to add a comment
      final response = await repository.addComment(
        reelId: reelId,
        comment: comment,
      );

      // Update the state based on the response
      log("${response.message}=====================================--------------------------------");
      emit(state.copyWith(
        isCommenting: true,
        commentResponse: response,
        commentErrorMessage: response.status ? null : "Failed to add comment",
      ));
    } catch (e) {
      // Handle errors and update the state accordingly
      emit(state.copyWith(
        isCommenting: false,
        commentErrorMessage: "An error occurred while adding the comment",
      ));
    }
  }

  Future<void> addReplayComment(String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    try {
      // Indicate that a comment is being added
      emit(state.copyWith(isCommenting: false));

      // Make the API call to add a comment
      final response = await repository.addReplayComment(
        reelId: reelId,
        comment: comment,
        receiverComment: receiverComment,
        parentCommentId: parentCommentId,
      );

      // Update the state based on the response
      log("${response.message}=====================================--------------------------------");
      emit(state.copyWith(
        isCommenting: true,
        commentResponse: response,
        commentErrorMessage: response.status ? null : "Failed to add comment",
      ));
    } catch (e) {
      // Handle errors and update the state accordingly
      emit(state.copyWith(
        isCommenting: false,
        commentErrorMessage: "An error occurred while adding the comment",
      ));
    }
  }

  Future<void> getComments(String reelId) async {
    try {
      emit(state.copyWith(isFetchingComments: false));
      final commentsResponse = await repository.fetchComments(reelId);
      log("${commentsResponse.data.first.comment}aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      emit(state.copyWith(
          isFetchingComments: true, fetchedComments: commentsResponse));
    } catch (e) {
      emit(state.copyWith(
          isFetchingComments: false,
          fetchCommentsErrorMessage: 'fetchCommentsError'));
    }
  }

  Future<void> toggleCommentLike(String commentId) async {
    try {
      emit(state.copyWith(isLikingComment: true));

      final message = await repository.toggleLike(commentId);

      if (message != null) {
        emit(state.copyWith(
          likeReelCommentResponseMessage: message,
        )); // Save the message ("like" or "unlike")
      }
    } catch (e) {
      emit(state.copyWith(
          isLikingComment: false,
          likeReelErrorMessage:
              'An error occurred while liking/unliking the comment'));
    }
  }

  Future<void> fetchReelsWithSameAudio(String audioId,
      {bool isInitialLoad = false}) async {
    if (state.globalReelsIsLoading || state.globalReelsHasReachedMax) return;

    emit(state.copyWith(isLoading: true));

    try {
      // If it's an initial load, start from the first page
      final int pageToFetch =
          isInitialLoad ? 1 : state.globalReelsCurrentPage + 1;

      final ReelsForAudioResponse response =
          await repository.fetchReelsWithSameAudio(audioId, page: pageToFetch);

      final bool hasReachedMax =
          pageToFetch >= response.data!.pagination!.pageCount!;

      final List<Reel> newReels = response.data?.reels ?? [];
      log(newReels.first.user!.firstName! +
          "----------------------------------------------------------------------------------------------");

      emit(state.copyWith(
        reelsForAudio:
            isInitialLoad ? newReels : [...?state.reelsForAudio, ...newReels],
        isLoading: false,
        hasReachedMax: hasReachedMax,
        currentPage: pageToFetch,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log("Error fetching reels with the same audio: $e");
    }
  }

  void updatePlayingIndex(int? index) {
    emit(state.copyWith(playingIndex: index));
  }
}
