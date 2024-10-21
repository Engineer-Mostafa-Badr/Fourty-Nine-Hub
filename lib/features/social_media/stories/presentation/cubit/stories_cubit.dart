import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/delete_story_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_followers_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_muted_stories_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/get_story_viewrs_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/make_view_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/mute_stories_use_case.dart';
import 'package:fourtyninehub/features/social_media/stories/domain/use_case/update_privacy_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;
import '../../../../../core/utils/shared_pref.dart';
import '../../data/models/followers_model.dart';

part  'stories_state.dart';

class StoryCubit extends Cubit<StoryState> {
  final StoryRepository storyRepository;
  final ApiConsumer apiConsumer;
  final MakeViewUseCase _makeViewUseCase;
  final MuteStoriesUseCase _muteStoriesUseCase;
  final GetMutedStoriesUseCase _getMutedStoriesUseCase;
  final GetStoryViewersUseCase _getStoryViewersUseCase;
  final GetFollowersUseCase _getFollowersUseCase;
  final UpdateStoryPrivacyUseCase _updateStoryPrivacyUseCase;
  final DeleteStoryUseCase _deleteStoryUseCase;

  StoryCubit(this.storyRepository,this.apiConsumer,this._deleteStoryUseCase, this._makeViewUseCase, this._muteStoriesUseCase, this._getMutedStoriesUseCase, this._getStoryViewersUseCase, this._getFollowersUseCase, this._updateStoryPrivacyUseCase) : super(StoryState());

  makeView({storyId, context}) async {
    getViewersInStory(context: context, storyId: storyId);

    // Map<String, dynamic> data = {};

    final response = await _makeViewUseCase(
      storyId,
    );
    response.fold(
      (failure) {
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

  // getMutedStories({userId, context, limit, page, bool? loadMore}) async {
  //   final response = await apiConsumer.get(
  //       'https://49dev.com/api/v1/stories/mutedStories?limit=$limit&page=$page');
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
  Future<void> getMutedStories({userId, context, limit = 1, page = 1, loadMore = false,}) async {
    try {
      final response = await _getMutedStoriesUseCase(
        PaginationParams(page: page,limit: limit),
      );

      response.fold(
        (failure) {
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
        print(
            '${getFailureMessage(failure, context)}assssssssssssssssssssssssssssssfffffffdsa');
        emit(state.copyWith(viewersResponse: null)); // Set loading state
      },
      (data) {
        // print(
        //     '${ViewersResponse.fromMap(data).data.first.createdAt.toString()}assssssssssssssssssssssssssssssfffffffdsa');

        emit(state.copyWith(
            viewersResponse:
                data)); // Set loading state
      },
    );
  }

  /// Fetch all followers based on subCategory ID
  Future<void> fetchFollowers() async {
    emit(state.copyWith(isLoading: true)); // Set loading state
    final response = await _getFollowersUseCase(const NoParams());
    response.fold(
          (failure) {
            emit(state.copyWith(
                isLoading: false, errorMessage: 'Failed to load followers'));
      },
          (data) {
            emit(state.copyWith(followers: data.data.followers, isLoading: false));

      },
    );
  }

  // New method to update story privacy
  Future<void> updateStoryPrivacy(String privacyType,
      {List<String>? users}) async {
    emit(state.copyWith(isLoading: true)); // Show loading state
    final response = await _updateStoryPrivacyUseCase(
      UpdateStoryPrivacyParams(privacyType: privacyType, users: users)
    );

    response.fold(
          (failure) {
            emit(StoryError('Failed to update privacy: $failure'));
      },
          (data) async {
            await fetchStories();
            emit(state.copyWith(isLoading: false)); // Reset loading state
      },
    );

  }

  Future<void> deleteStory(String storyId) async {
    try {
      emit(state.copyWith(isLoading: true));
      final response = await _deleteStoryUseCase(
          storyId
      );

      response.fold(
            (failure) {
          emit(StoryError('Failed to delete story: $failure'));
          emit(state.copyWith(isLoading: false)); // Reset loading state
        },
            (data) async {
              await fetchStories();
          emit(state.copyWith(isLoading: false)); // Reset loading state
        },
      );
      await storyRepository.deleteStory(storyId);
      // Remove the deleted story from the list
      // // final updatedStories = state.stories.where((story) => story.id != storyId).toList();
      // final updatedStories = state.stories.map((userStory) {
      //   // Filter the nested stories within each userStory
      //   final filteredStories = userStory.stories!
      //       .where((element) => element.id != storyId)
      //       .toList();
      //
      //   // Return the updated userStory with the filtered stories
      // }).where((userStory) {
      //   // Ensure we only keep userStories that still have stories after filtering
      //   return userStory!.stories!.isNotEmpty;
      // }).toList();
      //
      // emit(state.copyWith(stories: updatedStories));
    } catch (e) {
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> fetchStories({bool loadMore = false}) async {
    if ((loadMore && state.isFetchingMore) || (!loadMore && state.isLoading)) {
      return; // Prevent duplicate fetches
    }

    try {
      emit(state.copyWith(
        isLoading: !loadMore,
        isFetchingMore: loadMore,
      ));

      final listOfUserStories =
          await storyRepository.fetchStories(state.currentPage);

      if (listOfUserStories.isEmpty && loadMore) {
        // No more stories to load
        emit(state.copyWith(
          hasReachedMax: true,
          isLoading: false,
          isFetchingMore: false,
        ));
        return;
      }

      final newStories =
          loadMore ? [...state.users, ...listOfUserStories] : listOfUserStories;

      // Remove duplicates using a Map where keys are story IDs
      final uniqueStoriesMap = {
        for (var story in newStories) story.user!.id: story
      };
      final uniqueStories = uniqueStoriesMap.values.toList();

      emit(state.copyWith(
        stories: uniqueStories,
        hasReachedMax: loadMore && listOfUserStories.isEmpty,
        currentPage: state.currentPage + 1,
      ));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        isFetchingMore: false,
      ));
    }
  }

  // void fetchStories({bool loadMore = false}) async {
  //   if (loadMore && state.isFetchingMore) return;
  //
  //   if (!loadMore && state.isLoading) return;
  //
  //   emit(state.copyWith(
  //     isLoading: !loadMore,
  //     isFetchingMore: loadMore,
  //   ));
  //
  //   try {
  //     final listOfUserStories =
  //         await storyRepository.fetchStories(10, state.currentPage);
  //
  //     emit(state.copyWith(
  //       stories: loadMore
  //           ? [...state.stories, ...listOfUserStories]
  //           : listOfUserStories,
  //       isLoading: false,
  //       isFetchingMore: false,
  //       hasReachedMax: listOfUserStories.isEmpty,
  //       currentPage: state.currentPage + 1,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       isLoading: false,
  //       isFetchingMore: false,
  //     ));
  //     emit(StoryError(e.toString()));
  //   }
  // }

  void updateCurrentStoryCreatedAt(DateTime createdAt) {
    emit(state.copyWith(currentStoryCreatedAt: createdAt));
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
      await uploadStoryVideoOrImage(file, fileType, fileSize,
          description: description);
    } else {
      print('No file selected.');
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

  Future<void> uploadStoryVideoOrImage(File file, String fileType, int fileSize,
      {description}) async {
    final token = await CacheManager.getAccessToken();

    // Step 1: Generate Signed URL
    final response = await http.post(
      Uri.parse('https://49dev.com/api/v1/stories'),
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
        await confirmUpload(storyMediaId, description: description);
      } else {
        print('Failed to upload file: ${uploadResponse.statusCode}');
        print('Response body: ${uploadResponse.body}');
      }
    } else {
      print('Failed to generate signed URL: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> confirmUpload(String storyMediaId, {description = ''}) async {
    final token = await CacheManager.getAccessToken();

    final response = await http.put(
      Uri.parse(
          'https://49dev.com/api/v1/stories/success-upload/$storyMediaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
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

  Future<void> createTextStory(String text) async {
    try {
      final token = await CacheManager.getAccessToken();

      final response = await http.post(
        Uri.parse('https://49dev.com/api/v1/stories/text'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"text": text}),
      );

      log('${response.body}]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]');

      if (response.statusCode == 200) {
        log("${response.body}//////////////////////////////////////////////*******************************************");
      } else {
        log('error --------------------------------------------------------------------');
      }
    } catch (e) {
      log('error $e');
    }
  }

  void resetStories() {
    emit(state.copyWith(stories: List.empty()));
  }
}

showViewerList(BuildContext context, ViewersResponse viewers) async {
  await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (BuildContext context, ScrollController scrollController) {
          return Column(
            children: [
              // Beautiful Header Section with shadow effect
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
                      'Viewed by ${viewers.data.length}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 26,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.transparent),

              // Responsive List of Viewers
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey[100]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: viewers.data.length,
                    itemBuilder: (context, index) {
                      final viewer = viewers.data[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side:
                                BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                          leading: GestureDetector(
                            onTap: () => context.push(Routes.OTHERSACCOUNT,
                                extra: viewer.user.id),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(viewer
                                  .user.profile!.profilePicture!.mediaKey!),
                              backgroundColor: Colors.grey[300],
                            ),
                          ),
                          title: Text(
                            capitalizeAndSplit2Only(
                                "${viewer.user.firstName} ${viewer.user.lastName}"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            '',
                            // getTimeAgo(context, viewer.createdAt.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Text(
                            getTimeAgo(context, viewer.updatedAt.toString()),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {
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
      );
    },
  );
}

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
