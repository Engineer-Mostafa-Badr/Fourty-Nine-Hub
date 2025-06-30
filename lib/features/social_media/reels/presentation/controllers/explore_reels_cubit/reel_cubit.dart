import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/data_sources/reels_remote_data_source.dart';
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
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/upload_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/domain/use_case/upload_video_reel_use_case.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/media_preview.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/new_reels_model.dart';

part 'reel_state.dart';

class ReelsCubit extends Cubit<ReelsState> {
  final CreateReelUseCase _createReelUseCase;
  final CreateAdvertisementUseCase _advertisementUseCase;
  final GetExploreReelsUseCase _getExploreReelsUseCase;
  final GetFollowingReelsUseCase _getFollowingReelsUseCase;
  final SaveReelUseCase _saveReelUseCase;
  final ShareReelUseCase _shareReelUseCase;
  final LikeReelUseCase _likeReelUseCase;
  final AddReelCommentUseCase _addCommentUseCase;
  final AddReelReplyUseCase _addReplyUseCase;
  final GetCommentsUseCase _getCommentsUseCase;
  final ToggleCommentLikeUseCase _toggleCommentLikeUseCase;
  final ReelsWithSameAudioUseCase _reelsWithSameAudioUseCase;
  final UploadReelUseCase _uploadReelUseCase;
  final UploadVideoReelUseCase _uploadVideoReelUseCase;

  ReelsCubit(
      this._createReelUseCase,
      this._advertisementUseCase,
      this._getExploreReelsUseCase,
      this._getFollowingReelsUseCase,
      this._saveReelUseCase,
      this._shareReelUseCase,
      this._likeReelUseCase,
      this._addCommentUseCase,
      this._addReplyUseCase,
      this._getCommentsUseCase,
      this._toggleCommentLikeUseCase,
      this._reelsWithSameAudioUseCase,
      this._uploadReelUseCase,
      this._uploadVideoReelUseCase)
      : super(ReelsState(urls: [], controllers: {}, focusedIndex: 0, reloadCounter: 0, isLoading: false));

  var pauseChild = false;

  pauseChildVideo({bool pause = false}) {
    pauseChild = pause;

    emit(state);
  }

  void selectPrivacy({required String privacy}) {
    emit(state.copyWith(selectedPrivacy: privacy));
    print(state.selectedPrivacy);
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

  Future<void> uploadReel({
    required UploadReelParams params,
  }) async {
    emit(state.copyWith(status: ReelsStates.loading));

    final response = await _uploadReelUseCase(params);

    response.fold(
      (failure) {
        emit(state.copyWith(failure: failure, status: ReelsStates.error));
      },
      (data) {
        emit(state.copyWith(
          status: ReelsStates.uploadSuccess,
        ));
      },
    );
  }

  Future<void> uploadVideoReel({
    required UploadVideoReelParams params,
  }) async {
    log("lskjdfskjdfksjdfksjdf ن");
    emit(state.copyWith(status: ReelsStates.loading));

    final response = await _uploadVideoReelUseCase(params);

    response.fold(
      (failure) {
        log("lskjdfskjdfksjdfksjdf error");
        emit(state.copyWith(failure: failure, status: ReelsStates.error));
      },
      (data) {
        log("lskjdfskjdfksjdfksjdf");
        emit(state.copyWith(
          status: ReelsStates.uploadSuccess,
        ));
      },
    );
  }

  String? selectedVideo;
  String? selectedImage;

  Future<void> pickMediaFromGallery(BuildContext context) async {
    // final uploadFile = UploadFile2();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov'],
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = XFile(result.files.single.path!); // Use XFile here

        // Determine file type
        final fileType = pickedFile.path.split('.').last.toLowerCase();
        final isImage = ['jpg', 'jpeg', 'png'].contains(fileType);

        if (isImage) {
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              mediaPath: pickedFile.path,
              isImage: true,
            ),
          );
          // await uploadFile.uploadImage(
          //   file: pickedFile, // Pass XFile
          //   subCategoryId: '66a3583454e6e337915514db',
          //   onUploaded: (UploadFileEntity data) async {
          //     print("Uploaded Image Media ID: ${data.mediaId}");

          //     await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MediaPreviewScreen(
          //           mediaId: data.mediaId,
          //           mediaPath: pickedFile.path,
          //           isImage: true,
          //         ),
          //       ),
          //     );
          //   },
          // );
        } else {
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              mediaPath: pickedFile.path,
              isImage: false,
            ),
          );
          // await uploadFile.uploadVideo(
          //   file: pickedFile, // Pass XFile
          //   subCategoryId: '66a3583454e6e337915514db',
          //   onUploaded: (UploadFileEntity data) async {
          //     print("Uploaded Video Media ID: ${data.mediaId}");
          //     await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MediaPreviewScreen(
          //           mediaId: data.mediaId,
          //           mediaPath: pickedFile.path,
          //           isImage: false,
          //         ),
          //       ),
          //     );
          //   },
          // );
        }
      } else {
        print("No media selected.");
      }
    } catch (e) {
      print("Error picking media: $e");
    }
  }

  // uploadReel(){

  // }

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

  bool isLoadingReelsMore = false;
  bool hasMoreReelsData = true;
  int currentReelPage = 1;
  int reelPageSize = 20;

  Future<void> fetchReels() async {
    log("fetchReels called");
    if ((state.globalReelsIsLoading ?? false) ||
        (state.globalReelsHasReachedMax ?? false)) {
      return;
    }

    emit(state.copyWith(isLoading: true));
    final result = await _getExploreReelsUseCase(
        PaginationParams(page: currentReelPage, limit: reelPageSize));

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        emit(state.copyWith(
          reels: [...state.globalReels, ...data.data.reels],
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

    final result = await _getFollowingReelsUseCase(1);

    result.fold(
      (failure) =>
          emit(state.copyWith(reelViewErrorMessage: failure.toString())),
      (data) {
        emit(state.copyWith(
          reelsForFollowing: [
            ...state.reelsForFollowing ?? [],
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
        emit(state.copyWith(reelSaveResponse: data));
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
    result.fold((failure) {
      showErrorMessage(context, getFailureMessage(failure, context));
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
      comments.insert(0, newComment);
      emit(state.copyWith(
        isCommenting: false,
        commentResponse: addCommentResponse,
      ));
    });
  }

  Future<void> addReplayComment(
      BuildContext context, String reelId, String comment,
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
          profilePictureSignedUrl:
              context.read<UserCubit>().state.data!.profilePicture ??
                  UIConst.profilePlaceHolder,
        ),
        parentId: addCommentResponse.data.parentId,
        receiverComment: addCommentResponse.data.receiverComment,
        replies: [],
      );
      final parentCommentIndex = comments.indexWhere(
        (comment) => comment.id == parentCommentId,
      );
      if (parentCommentIndex != -1) {
        comments[parentCommentIndex].replies.insert(0, newReply);
      }
      if (comments[parentCommentIndex].replies.length == 1) {
        _scrollToFirstReply();
      } else {
        _scrollToLatestReply();
      }
      emit(state.copyWith(
        isReplyingComment: false,
        commentResponse: addCommentResponse,
        commentErrorMessage:
            addCommentResponse.status ? null : "Failed to add comment",
      ));
    });
  }

  final ScrollController replyScrollController = ScrollController();

  void _scrollToLatestReply() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (replyScrollController.hasClients) {
        replyScrollController.animateTo(
          replyScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToFirstReply() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (replyScrollController.hasClients) {
        replyScrollController.animateTo(
          0.0, // Scroll to the top of replies
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<CommentData> comments = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 10;

  void loadInitialComments(String reelId) async {
    emit(state.copyWith(isFetchingComments: true));
    comments.clear();
    currentPage = 1;
    hasMoreData = true;
    await getComments(reelId);
  }

  Future<void> getComments(String reelId) async {
    if (!hasMoreData || isLoadingMore) return;

    bool isFetching = true;
    final result = await _getCommentsUseCase(CommentParams(
        reelId: reelId,
        pagingParams: PaginationParams(page: currentPage, limit: pageSize)));
    result.fold((failure) {
      isFetching = false;
      emit(state.copyWith(
          isFetchingComments: isFetching,
          fetchCommentsErrorMessage: 'fetchCommentsError'));
    }, (data) {
      comments.addAll(data.data);
      if (data.data.length < pageSize) {
        hasMoreData = false;
      } else {
        currentPage++;
      }

      isLoadingMore = false;

      isFetching = false;
      emit(state.copyWith(
          isFetchingComments: isFetching, fetchedComments: data));
    });
  }

  Future<void> toggleCommentLike(String commentId, bool isReply,
      {String? replyId}) async {
    emit(state.copyWith(isLikingComment: true));
    final result = await _toggleCommentLikeUseCase(
        isReply == true ? replyId ?? '' : commentId);
    result.fold((failure) {
      emit(state.copyWith(
          isLikingComment: false,
          likeReelErrorMessage:
              'An error occurred while liking/unliking the comment'));
    }, (data) {
      // Debugging output

      final updatedComments = comments.map((comment) {
        if (isReply) {
          // Debug: Check if we are updating a reply

          final updatedReplies = comment.replies.map((reply) {
            if (reply.id == replyId) {
              // print("Found matching reply with id: ${reply.id}"); // Debugging output

              final isLiked = data == "like";
              reply.isLiked = isLiked;
              reply.likeCount =
                  isLiked ? reply.likeCount + 1 : reply.likeCount - 1;
              return reply;
            }
            return reply;
          }).toList();
          // Return the comment with updated replies
          comment.replies.clear();
          comment.replies.addAll(updatedReplies);
          return comment;
        } else {
          // Debug: Check if we are updating a main comment

          // If it's a main comment, update the main comment like data
          if (comment.id == commentId) {
            // Debugging output

            final isLiked = data == "like";
            // return comment.copyWith(
            //   isLiked: isLiked,
            //   likeCount:
            //       isLiked ? comment.likeCount + 1 : comment.likeCount - 1,
            // );
            comment.isLiked = isLiked;
            comment.likeCount =
                isLiked ? comment.likeCount + 1 : comment.likeCount - 1;
            return comment;
          }
        }
        return comment; // Return the original comment if no changes were made
      }).toList();

      GetCommentsResponse updatedCommentsResponse =
          state.fetchedComments!.copyWith(data: updatedComments);

      emit(state.copyWith(
        isLikingComment: false,
        fetchedComments: updatedCommentsResponse,
        likeReelCommentResponseMessage: data,
      ));
    });
  }

  Future<void> fetchReelsWithSameAudio(String audioId,
      {bool isInitialLoad = false}) async {
    emit(state.copyWith(isLoading: true));

    final result = await _reelsWithSameAudioUseCase(
        ReelsWithSameAudioParams(audioId: audioId));
    result.fold((failure) {
      emit(state.copyWith(isLoading: false));
    }, (data) {
      final List<Reel> newReels = data.data?.reels ?? [];
      log("${newReels.first.user.firstName}----------------------------------------------------------------------------------------------");

      emit(state.copyWith(
        reelsForAudio: newReels,
        isLoading: false,
      ));
    });
  }

  void updatePlayingIndex(int? index) {
    emit(state.copyWith(playingIndex: index));
  }

  String? parentCommentId;
  String? receiverComment;

  void updateParentCommentIdAndReceiverComment(
      {String? parentCommentId, String? receiverComment}) {
    emit(state.copyWith(isCreatingReply: false));
    this.parentCommentId = parentCommentId;
    this.receiverComment = receiverComment;
    emit(state.copyWith(isCreatingReply: true));
  }







  //Preloading
  //
  //
  // // Set the loading state
  // void setLoading(bool isLoading) {
  //   emit(state.copyWith(isLoading: isLoading));
  // }
  //
  // void resetFocusedIndex(int index) {
  //   emit(state.copyWith(focusedIndex: 0, reloadCounter: 0));
  //   _disposeControllerAtIndex(index);
  // }
  //
  // // Fetch videos from the API and initialize controllers for the first videos
  // Future<void> getVideosFromApi() async {
  //   setLoading(true);
  //   try {
  //     log('Fetching videos from API');
  //     await fetchReels();
  //     final List<String> urls = getReelVideos(globalReels: state.globalReels);
  //     log('Fetched URLs: $urls');
  //
  //     final updatedUrls = List<String>.from(state.urls)..addAll(urls);
  //     log('message urls: ${updatedUrls.length}');
  //     emit(state.copyWith(
  //       urls: updatedUrls,
  //       isLoading: false,
  //       reloadCounter: state.reloadCounter + 1,
  //     ));
  //
  //     await _initializeControllerAtIndex(0);
  //     _playControllerAtIndex(0);
  //     await _initializeControllerAtIndex(1);
  //
  //     log('API fetch complete');
  //   } catch (e) {
  //     log('error occurred $e');
  //     setLoading(false);
  //     rethrow;
  //   }
  // }
  //
  // // Handle video index change and preload logic
  // void onVideoIndexChanged(int index) {
  //   // final shouldFetch = (index + kPreloadLimit) % kNextLimit == 0 &&
  //   //     state.urls.length == index + kPreloadLimit;
  //   final shouldFetch = index + kPreloadLimit >= state.urls.length;
  //   if (shouldFetch) {
  //     preloadVideos(index,state.globalReels);
  //   }
  //
  //   if (index > state.focusedIndex) {
  //     _playNext(index);
  //   } else {
  //     _playPrevious(index);
  //   }
  //
  //   emit(state.copyWith(focusedIndex: index));
  // }
  //
  // // Update the list of URLs with new videos
  // void updateUrls(List<String> newUrls) {
  //   final updatedUrls = List<String>.from(state.urls)..addAll(newUrls);
  //
  //   _initializeControllerAtIndex(state.focusedIndex + 1);
  //   emit(state.copyWith(
  //     urls: updatedUrls,
  //     reloadCounter: state.reloadCounter + 1,
  //     isLoading: false,
  //   ));
  //   log('🚀🚀🚀 NEW VIDEOS ADDED');
  // }
  //
  // // Private helper methods for managing video player controllers
  // void _playNext(int index) {
  //   _stopControllerAtIndex(index - 1);
  //   _disposeControllerAtIndex(index - 2);
  //   _playControllerAtIndex(index);
  //   _initializeControllerAtIndex(index + 1);
  // }
  //
  // void _playPrevious(int index) {
  //   _stopControllerAtIndex(index + 1);
  //   _disposeControllerAtIndex(index + 2);
  //   _playControllerAtIndex(index);
  //   if (index == 0) return;
  //   _initializeControllerAtIndex(index - 1);
  // }
  //
  // Future<void> _initializeControllerAtIndex(int index) async {
  //   if (index < 0 || index >= state.urls.length) {
  //     log('❌ Invalid index: $index. URLs length: ${state.urls.length}');
  //     return;
  //   }
  //
  //   final controller = VideoPlayerController.networkUrl(state.urls[index].toUri);
  //   state.controllers[index] = controller;
  //
  //   await controller.initialize();
  //   log('🚀 INITIALIZED $index');
  // }
  //
  // void _playControllerAtIndex(int index) {
  //   final controller = state.controllers[index];
  //   controller?.play();
  //   log('🚀🚀🚀 PLAYING $index');
  // }
  //
  // void _stopControllerAtIndex(int index) {
  //   final controller = state.controllers[index];
  //   controller?.pause();
  //   // controller?.seekTo(Duration.zero);
  //   log('🚀🚀🚀 STOPPED $index');
  // }
  //
  // void _disposeControllerAtIndex(int index) {
  //   final controller = state.controllers.remove(index);
  //   controller?.dispose();
  //   log('🚀🚀🚀 DISPOSED $index');
  // }
  //
  // void _disposeAllControllers() {
  //   for (var controller in state.controllers.values) {
  //     controller.dispose();
  //   }
  // }
}
