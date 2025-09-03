import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../../chat/chat_room/domain/usecases/send_message_usecase.dart';
import '../../../chat/chat_view/domain/entities/chat_entity.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../data/models/followers_model.dart';
import '../../data/models/friends_stories_model.dart';
import '../../data/models/muted_stories_model.dart';
import '../../data/models/viewers_model.dart';
import '../../domain/use_case/create_story_use_case.dart';
import '../../domain/use_case/delete_story_use_case.dart';
import '../../domain/use_case/fetch_stories_use_case.dart';
import '../../domain/use_case/get_followers_use_case.dart';
import '../../domain/use_case/get_muted_stories_use_case.dart';
import '../../domain/use_case/get_story_viewrs_use_case.dart';
import '../../domain/use_case/make_like_usecase.dart';
import '../../domain/use_case/make_view_use_case.dart';
import '../../domain/use_case/mute_stories_use_case.dart';
import '../../domain/use_case/update_privacy_use_case.dart';

part 'stories_state.dart';

// Example Data
final List<Map<String, dynamic>> viewers = [
  {
    'name': 'Rasha Hashem',
    'profilePic': 'https://example.com/rasha.jpg',
    'time': 'Today, 6:35 AM',
    'statusIcon': Icons.favorite,
  },
  {
    'name': 'DmitryZ ADNOC',
    'profilePic': 'https://example.com/dmitry.jpg',
    'time': 'Today, 4:39 PM',
  },
  {
    'name': 'Sherif Far3',
    'profilePic': 'https://example.com/sherif.jpg',
    'time': 'Today, 4:02 PM',
  },
];

// showViewerList(BuildContext context, ViewersResponse viewers) async {
//   await showModalBottomSheet(
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white.withOpacity(0.9),
//     builder: (BuildContext context) {
//       return DraggableScrollableSheet(
//         expand: false,
//         initialChildSize: 0.5,
//         maxChildSize: 0.9,
//         minChildSize: 0.3,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return Column(
//             children: [
//               // Beautiful Header Section with shadow effect
//               Container(
//                 decoration: const BoxDecoration(
//                   color: AppColors.PRIMARY_COLOR,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       offset: Offset(0, -3),
//                       blurRadius: 10,
//                     ),
//                   ],
//                 ),
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       context.isArabic
//                           ? 'شوهدت بواسطة ${viewers.data.length}'
//                           : 'Viewed by ${viewers.data.length}',
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     Navigator.pop(context);
//                     //   },
//                     //   child: const Icon(
//                     //     Icons.close,
//                     //     size: 26,
//                     //     color: Colors.black54,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//               // const Divider(thickness: 1, color: Colors.transparent),

//               // Responsive List of Viewers
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: ListView.builder(
//                     controller: scrollController,
//                     itemCount: viewers.data.length,
//                     itemBuilder: (context, index) {
//                       final viewer = viewers.data[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(8),
//                           tileColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             side:
//                                 BorderSide(color: Colors.grey[300]!, width: 1),
//                           ),
//                           leading: GestureDetector(
//                             onTap: () => context.push(Routes.OTHERSACCOUNT,
//                                 extra: viewer.user.id),
//                             child: CircleAvatar(
//                               radius: 19,
//                               backgroundColor: AppColors.PRIMARY_COLOR_DARK,
//                               child: CircleAvatar(
//                                 radius: 16,
//                                 backgroundImage: NetworkImage(viewer
//                                     .user.profile!.profilePicture!.mediaKey!),
//                                 backgroundColor: Colors.grey[300],
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             capitalizeAndSplit2Only(
//                                 "${viewer.user.firstName} ${viewer.user.lastName}"),
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.black.withOpacity(0.8),
//                             ),
//                           ),
//                           subtitle: Text(
//                             '',
//                             // getTimeAgo(context, viewer.createdAt.toString()),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           trailing: Text(
//                             getTimeAgo(context, viewer.updatedAt.toString()),
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           onTap: () {
//                             // Optional: Add tap functionality here
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

showViewerList(BuildContext context, ViewersResponse viewers) async {
  await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white.withOpacity(0.9),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              // Bottom Sheet Content
              DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.5,
                maxChildSize: 0.9,
                minChildSize: 0.3,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Column(
                    children: [
                      // Beautiful Header Section with shadow effect
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, -3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.isArabic
                                  ? 'شوهدت بواسطة ${viewers.data.length}'
                                  : 'Viewed by ${viewers.data.length}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Responsive List of Viewers
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: viewers.data.length,
                            itemBuilder: (context, index) {
                              final viewer = viewers.data[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        color: Colors.grey[300]!, width: 1),
                                  ),
                                  leading: GestureDetector(
                                    onTap: () => context.push(
                                        Routes.OTHERSACCOUNT,
                                        extra: viewer.user.id),
                                    child: CircleAvatar(
                                      radius: 19,
                                      backgroundColor:
                                          AppColors.PRIMARY_COLOR_DARK,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(viewer
                                            .user
                                            .profile!
                                            .profilePicture!
                                            .mediaKey!),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    capitalizeAndSplit2Only(
                                        "${viewer.user.firstName} ${viewer.user.lastName}"),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                  trailing: Text(
                                    getTimeAgo(
                                        context, viewer.updatedAt.toString()),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    // Optional: Add tap functionality here
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Animated Hearts Overlay
              viewers.data.isNotEmpty
                  ? Positioned.fill(
                      child: HeartAnimationWidget(),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      );
    },
  );
}

class HeartAnimationWidget extends StatefulWidget {
  const HeartAnimationWidget({super.key});

  @override
  _HeartAnimationWidgetState createState() => _HeartAnimationWidgetState();
}

class StoryCubit extends Cubit<StoryState> {
  final CreateStoryUseCase _createStoryUseCase;
  final MakeViewUseCase _makeViewUseCase;
  final MuteStoriesUseCase _muteStoriesUseCase;
  final GetMutedStoriesUseCase _getMutedStoriesUseCase;
  final GetStoryViewersUseCase _getStoryViewersUseCase;
  final GetFollowersUseCase _getFollowersUseCase;
  final UpdateStoryPrivacyUseCase _updateStoryPrivacyUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;
  final FetchStoriesUseCase _fetchStoriesUseCase;
  final MakeLikeUseCase _makeLikeUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  StoryCubit(
    this._createStoryUseCase,
    this._deleteStoryUseCase,
    this._fetchStoriesUseCase,
    this._makeViewUseCase,
    this._muteStoriesUseCase,
    this._getMutedStoriesUseCase,
    this._getStoryViewersUseCase,
    this._getFollowersUseCase,
    this._updateStoryPrivacyUseCase,
    this._makeLikeUseCase,
    this._sendMessageUseCase,
  ) : super(StoryState());

  Future<void> confirmUpload(String storyMediaId,
      {description = '', String? color}) async {
    final token = await CacheManager.getAccessToken();

    final response = await http.put(
      Uri.parse(
          'https://31b3c19d4d0a.ngrok-free.app/api/v1/stories/success-upload/$storyMediaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: color != null
          ? jsonEncode({
              "description": "$description", // Add your actual description here
              "color": color,
            })
          : jsonEncode({
              "description": "$description", // Add your actual description here
            }),
    );

    if (response.statusCode == 200) {
      print('Upload confirmed successfully!');
    } else {
      print('Failed to confirm upload: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> createTextStory(
      {required String text,
      required String color,
      required String fontFamily}) async {
    final response = await _createStoryUseCase(CreateStoryParams(
      text: text,
      color: color,
      fontFamily: fontFamily,
    ));
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(StoryError('Failed to create story: $failure'));
      },
      (data) async {
        // log("createTextStory: $data");
        await fetchStories();
        await getMutedStories();
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
    );
  }

  Future<void> deleteStory(String storyId) async {
    emit(state.copyWith(isLoading: true));

    final response = await _deleteStoryUseCase(storyId);

    response.fold(
      (failure) async {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        await fetchStories();
        emit(StoryError('Failed to delete story: $failure'));
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
      (data) async {
        state.users[0].stories!.removeWhere((story) => story.id == storyId);
        await fetchStories();
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
    );
  }

  /// Fetch all followers based on subCategory ID
  Future<void> fetchFollowers() async {
    emit(state.copyWith(isLoading: true)); // Set loading state
    final response = await _getFollowersUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            isLoading: false, errorMessage: 'Failed to load followers'));
      },
      (data) {
        emit(state.copyWith(followers: data.data.followers, isLoading: false));
      },
    );
  }

  Future<void> fetchStories({bool loadMore = true}) async {
    if ((loadMore && state.isFetchingMore) || (!loadMore && state.isLoading)) {
      return; // Prevent duplicate fetches
    }

    emit(state.copyWith(
      isLoading: !loadMore,
      isFetchingMore: loadMore,
    ));
    // _fetchStoriesUseCase
    final response =
        await _fetchStoriesUseCase(PaginationParams(page: 1, limit: 100));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(StoryError('Failed to fetch stories: $failure'));
      },
      (data) async {
        final listOfUserStories = data.data?.userStories ?? [];
        final newStories = loadMore
            ? [...state.users, ...listOfUserStories]
            : listOfUserStories;

        emit(state.copyWith());
        final uniqueStoriesMap = {
          for (var story in newStories) story.user!.id: story
        };
        final uniqueStories = uniqueStoriesMap.values.toList();

        emit(state.copyWith(
          stories: uniqueStories,
          hasReachedMax: loadMore && listOfUserStories.isEmpty,
          currentPage: state.currentPage + 1,
          isLoading: false,
          isFetchingMore: false,
        ));
      },
    );
  }

  // getMutedStories({userId, context, limit, page, bool? loadMore}) async {
  //   final response = await apiConsumer.get(
  //       'https://31b3c19d4d0a.ngrok-free.app/api/v1/stories/mutedStories?limit=$limit&page=$page');
  //   print('from getMutedStories ');
  //
  //   response.fold(
  //     (failure) {
  //       // emit(state);
  //       print('assssssssssssssssssgetMutedStoriesssssssssssssfffffffdsa');
  //     },
  //     (data) {
  //       // emit(state);
  //       // print(
  //       //     'assssssssssssssssssgetMutedStoriesssssssssssssfffffffdsa');
  //
  //       log('${data.toString()}assssssssssssssssssgetMutedStoriesssssssssssssfffffffdsa');
  //
  //       emit(state.copyWith(
  //           mutedStoriesResponse: MutedStoriesResponse.fromJson(data)));
  //     },
  //   );
  // }

  Future<void> getMutedStories({
    userId,
    context,
    limit = 10,
    page = 1,
    loadMore = false,
  }) async {
    try {
      final response = await _getMutedStoriesUseCase(
        PaginationParams(page: page, limit: limit),
      );

      response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          print('Error fetching muted stories');
        },
        (data) {
          // Parse the response
          final newData = data;

          // If loadMore is true, append new stories to the existing list
          if (loadMore) {
            if (newData.data.stories.isEmpty) return;
            final currentStories =
                state.mutedStoriesResponse?.data.stories ?? [];
            final updatedStories = [
              ...currentStories,
              ...newData.data.stories,
            ];

            final updatedResponse = MutedStoriesResponse(
              status: newData.status,
              message: newData.message,
              data: MutedStoriesData(
                stories: updatedStories,
                pagination: newData.data.pagination,
              ),
            );

            // Update the state with the appended stories
            emit(state.copyWith(mutedStoriesResponse: updatedResponse));
          } else {
            // If not loading more, replace the current stories with new data
            emit(state.copyWith(mutedStoriesResponse: newData));
          }
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      print('Unexpected error occurred: $e');
    }
  }

  getViewersInStory({storyId, context}) async {
    final response = await _getStoryViewersUseCase(
      storyId,
    );
    emit(state.copyWith(viewersResponse: null)); // Set loading state

    return response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        print(
            '${getFailureMessage(failure, context)}assssssssssssssssssssssssssssssfffffffdsa');
        emit(state.copyWith(viewersResponse: null)); // Set loading state
      },
      (data) {
        // print(
        //     '${ViewersResponse.fromMap(data).data.first.createdAt.toString()}assssssssssssssssssssssssssssssfffffffdsa');

        emit(state.copyWith(viewersResponse: data)); // Set loading state
      },
    );
  }

  Future<void> makeLike(String storyId) async {
    emit(state.copyWith(isLoading: true));

    final response = await _makeLikeUseCase(storyId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(StoryError('Failed to make like: $failure'));
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
      (data) async {
        // await fetchStories();
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
    );
  }

  makeView({storyId, context}) async {
    getViewersInStory(context: context, storyId: storyId);

    final response = await _makeViewUseCase(
      storyId,
    );
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state);
        print(
            '${getFailureMessage(failure, context)}assssssssssssssssssssssssssssssfffffffdsa');
      },
      (data) {
        emit(state);

        print('${data.toString()}assssssssssssssssssssssssssssssfffffffdsa');
      },
    );
  }

  muteUserStories({userId, context}) async {
    final response = await _muteStoriesUseCase(
      userId,
    );

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state);
        print(
            '${getFailureMessage(failure, context)}assssssssssssssssssssssssssssssfffffffdsa');
      },
      (data) {
        emit(state);

        print('${data.toString()}assssssssssssssssssssssssssssssfffffffdsa');
        getMutedStories();
      },
    );
  }

  Future<void> pickAndUploadStory({description}) async {
    final picker = ImagePicker();

    // Pick an image or video
    final XFile? pickedFile = await picker.pickMedia(
        // allowedExtensions: ['jpg', 'png', 'mp4'], // Optional: filter allowed extensions
        );

    if (pickedFile != null) {
      // Convert the picked file to a File object
      final file = File(pickedFile.path);

      // Determine the file type based on the file extension
      final fileType = _determineFileType(file.path);

      // Get the file size
      final fileSize = await file.length();

      // Call your upload method
      await uploadStoryVideoOrImageOrVoice(file, fileType, fileSize,
          description: description);
    } else {
      print('No file selected.');
    }
  }

  void resetStories() {
    emit(state.copyWith(stories: List.empty()));
  }

  Future<void> sendMessage(
      {required ChatEntity chat, required String message}) async {
    final result = await _sendMessageUseCase(SendMessageParams(
      message: message,
      chat: chat,
      media: [],
      sharedContacts: [],
      oneTimeView: false,
      isForward: false,
    ));
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state);
    }, (r) async {
      emit(state);
    });
  }

  void updateCurrentStoryCreatedAt(DateTime createdAt) {
    emit(state.copyWith(currentStoryCreatedAt: createdAt));
  }

  // New method to update story privacy
  Future<void> updateStoryPrivacy(String privacyType,
      {List<String>? users}) async {
    emit(state.copyWith(isLoading: true)); // Show loading state
    final response = await _updateStoryPrivacyUseCase(
        UpdateStoryPrivacyParams(privacyType: privacyType, users: users));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(StoryError('Failed to update privacy: $failure'));
      },
      (data) async {
        await fetchStories();
        emit(state.copyWith(isLoading: false)); // Reset loading state
      },
    );
  }

  Future<void> uploadStoryVideoOrImageOrVoice(
      File file, String fileType, int fileSize,
      {description, String? color}) async {
    final token = await CacheManager.getAccessToken();

    // Step 1: Generate Signed URL
    final response = await http.post(
      Uri.parse('https://31b3c19d4d0a.ngrok-free.app/api/v1/stories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "type": fileType,
        "size": fileSize,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final signedUrl = responseData['data']['signedUrl'];

      // Step 2: Upload the file using the Signed URL
      final uploadResponse = await http.put(
        Uri.parse(signedUrl),
        headers: {
          'Content-Type': fileType,
        },
        body: file.readAsBytesSync(),
      );

      if (uploadResponse.statusCode == 200) {
        print('File uploaded successfully!');

        // Optional: Confirm upload

        print(
            'Response body: ${responseData['data']['mediaId']}***************************************');

        final storyMediaId = responseData['data']['mediaId'];
        await confirmUpload(storyMediaId,
            description: description, color: color);
      } else {
        print('Failed to upload file: ${uploadResponse.statusCode}');
        print('Response body: ${uploadResponse.body}');
      }
    } else {
      print('Failed to generate signed URL: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  String _determineFileType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    if (extension == '.mp4') {
      return 'video/mp4';
    } else if (['.jpg', '.jpeg', '.png'].contains(extension)) {
      return 'image/jpeg'; // Adjust this if you want different handling for PNG, etc.
    } else {
      throw Exception('Unsupported file type');
    }
  }
}

class __AnimatedHeartState extends State<_AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _yAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _sizeAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, -_yAnimation.value),
            child: Icon(
              Icons.favorite,
              color: AppColors.PRIMARY_COLOR_DARK,
              size: _sizeAnimation.value,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _yAnimation = Tween<double>(
      begin: 0,
      end: widget.endY,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _sizeAnimation = Tween<double>(
      begin: 20.0,
      end: 50.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.dispose();
      }
    });
  }
}

class _AnimatedHeart extends StatefulWidget {
  final double endY;

  const _AnimatedHeart({required this.endY});

  @override
  __AnimatedHeartState createState() => __AnimatedHeartState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final List<Widget> _hearts = [];
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _hearts,
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Start generating hearts periodically
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      _generateHeart();
    });
  }

  void _generateHeart() {
    final double startX =
        _random.nextDouble() * MediaQuery.of(context).size.width;
    final double endY = MediaQuery.of(context).size.height * 0.1;

    final heart = Positioned(
      left: startX,
      bottom: 0,
      child: _AnimatedHeart(endY: endY),
    );

    setState(() {
      _hearts.add(heart);
    });

    // Remove the heart after animation is done
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _hearts.remove(heart);
      });
    });
  }
}
