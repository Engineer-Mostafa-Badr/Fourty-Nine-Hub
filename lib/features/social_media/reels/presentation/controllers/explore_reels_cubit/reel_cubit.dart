import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
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
import 'package:fourtyninehub/res/style/const.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../../../../../core/utils/shared_pref.dart';
import '../../../../../trip_join/helpers/print_helper.dart';
import '../../../data/models/new_reels_model.dart';

part 'reel_state.dart';

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

  var pauseChild = false;

  pauseChildVideo({bool pause = false}) {
    pauseChild = pause;

    emit(state);
  }

  Future<void> createReelView(String reelId, int duration) async {
    emit(state.copyWith(isCreatingReelView: true));

    final result = await _createReelUseCase(
      CreateReelParams(reelId: reelId, duration: duration),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) => emit(state.copyWith(reelViewSuccess: true)),
    );
  }

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
      } else {}
    } else {}
  }

  Future<void> createAdvertisement(
      List<String> mediaIds, String type, double totalPrice) async {
    final result = await _advertisementUseCase(
      CreateAdvertisementParams(
          type: type, mediaIds: mediaIds, totalPrice: totalPrice),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {},
    );
  }

  Future<void> fetchReels() async {
    if ((state.globalReelsIsLoading ?? false) ||
        (state.globalReelsHasReachedMax ?? false)) return;

    emit(state.copyWith(isLoading: true));
    final result = await _getExploreReelsUseCase(1);

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        emit(state.copyWith(
          reels: [...state.globalReels ?? [], ...data.data.reels],
          isLoading: false,
          hasReachedMax: data.data.pagination.currentPage >=
              data.data.pagination.pageCount,
          currentPage: data.data.pagination.currentPage,
        ));
      },
    );
  }

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
  }

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
  }

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
  }



  Future<String> likeReel(String reelId) async {
    emit(state.copyWith(
        isLikingReel: true, likeReelErrorMessage: 'loadingLike'));
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
  }

  Future<void> addComment(BuildContext context, String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    emit(state.copyWith(isCommenting: true));
    final result = await _addCommentUseCase(
        AddReelCommentParams(comment: comment, reelId: reelId));
    result.fold(
            (failure) {
          showErrorMessage(context,getFailureMessage(failure, context));
          emit(state.copyWith(
            isCommenting: false,
            commentErrorMessage: "An error occurred while adding the comment",
          ));
        }, (addCommentResponse) {
      final newComment = CommentData(
        id: addCommentResponse.data.id,
        reelId: addCommentResponse.data.reelId,
        comment: addCommentResponse.data.comment,
        createdAt: addCommentResponse.data.createdAt,
        updatedAt: addCommentResponse.data.updatedAt,
        likeCount: 0,
        isLiked: false,
        user: UserComment(
          firstName: context.read<UserCubit>().state.data!.firstName,
          id: context.read<UserCubit>().state.data!.id,
          lastName: context.read<UserCubit>().state.data!.lastName,
          profilePictureSignedUrl:
          context.read<UserCubit>().state.data!.profilePicture ??
              UIConst.profilePlaceHolder,
        ),
        parentId: addCommentResponse.data.parentId,
        receiverComment: addCommentResponse.data.receiverComment,
        replies: [], // Initialize with an empty replies list
      );
      state.fetchedComments!.data.insert(0, newComment);
      emit(state.copyWith(
        isCommenting: false,
        commentResponse: addCommentResponse,
      ));
    });
  }

  Future<void> addReplayComment(BuildContext context,String reelId, String comment,
      {String? receiverComment, String? parentCommentId}) async {
    //parent comment id is comment (global) Main comment
    //receiver comment is reply or
    emit(state.copyWith(isReplyingComment: true));
    final result = await _addReplyUseCase(AddReelReplyParams(
        comment: comment,
        reelId: reelId,
        parentCommentId: parentCommentId,
        receiverComment: receiverComment));
    result.fold(
        (failure) => emit(state.copyWith(
              isReplyingComment: false,
              commentErrorMessage: "An error occurred while adding the comment",
            )), (AddCommentResponse addCommentResponse) {
      final newReply = CommentData(
        id: addCommentResponse.data.id,
        reelId: addCommentResponse.data.reelId,
        comment: addCommentResponse.data.comment,
        createdAt: addCommentResponse.data.createdAt,
        updatedAt: addCommentResponse.data.updatedAt,
        likeCount: 0,
        isLiked: false,
        user: UserComment(
          firstName: context.read<UserCubit>().state.data!.firstName,
          id: context.read<UserCubit>().state.data!.id,
          lastName: context.read<UserCubit>().state.data!.lastName,
          profilePictureSignedUrl: context.read<UserCubit>().state.data!.profilePicture ?? UIConst.profilePlaceHolder,
        ),
        parentId: addCommentResponse.data.parentId,
        receiverComment: addCommentResponse.data.receiverComment,
        replies: [], // Initialize with an empty replies list
      );

      // Find the parent comment by matching parentCommentId
      final parentCommentIndex = state.fetchedComments!.data.indexWhere(
            (comment) => comment.id == parentCommentId,
      );

      if (parentCommentIndex != -1) {
        // Add the new reply to the parent comment's replies list
        state.fetchedComments!.data[parentCommentIndex].replies.insert(0, newReply);
      }

      emit(state.copyWith(
        isReplyingComment: false,
        commentResponse: addCommentResponse,
        commentErrorMessage: addCommentResponse.status ? null : "Failed to add comment",
      ));
    });
  }

  Future<void> getComments(String reelId) async {
    bool isFetching = true;
    print('initial isFetching: $isFetching');
    emit(state.copyWith(isFetchingComments: isFetching));
    print('reelId: $reelId');
    final result = await _getCommentsUseCase(reelId);
    result.fold((failure) {
      isFetching = false;
      print('isFetching is false and failure');
      emit(state.copyWith(
          isFetchingComments: isFetching,
          fetchCommentsErrorMessage: 'fetchCommentsError'));
    }, (data) {
      isFetching = false;
      print('isFetching is false and success');
      emit(state.copyWith(
          isFetchingComments: isFetching, fetchedComments: data));
    });
  }

  Future<void> toggleCommentLike(String commentId) async {
    emit(state.copyWith(isLikingComment: true));
    final result = await _toggleCommentLikeUseCase(commentId);
    result.fold(
        (failure) => emit(state.copyWith(
            isLikingComment: false,
            likeReelErrorMessage:
                'An error occurred while liking/unliking the comment')),
        (data) {
          // Find the target comment by its ID in the comment list
          final updatedComments = state.fetchedComments!.data.map((comment) {
            if (comment.id == commentId) {
              // Determine if the action was a "like" or "unlike" and update accordingly
              final isLiked = data == "like";
              return comment.copyWith(
                isLiked: isLiked,
                likeCount: isLiked ? comment.likeCount + 1 : comment.likeCount - 1,
              );
            }
            return comment;
          }).toList();
      emit(state.copyWith(
        isLikingComment: false,
        fetchedComments: state.fetchedComments!.copyWith(data: updatedComments),
        likeReelCommentResponseMessage: data,
      )); // Save the message ("like" or "unlike")
    });
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
  }

  void updatePlayingIndex(int? index) {
    emit(state.copyWith(playingIndex: index));
  }

  String? parentCommentId;
  String? receiverComment;
  void updateParentCommentIdAndReceiverComment(
      { String? parentCommentId, String? receiverComment}) {
    emit(state.copyWith(isCreatingReply: false));
    this.parentCommentId = parentCommentId;
    this.receiverComment = receiverComment;
    emit(state.copyWith(isCreatingReply: true));

  }
}
