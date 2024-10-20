import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/muted_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/viewers_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;
import '../../../../../core/utils/shared_pref.dart';
import '../../data/models/followers_model.dart';

class StoryState {
  List<UserStories> users;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;
  final bool isFetchingMore;
  final DateTime? currentStoryCreatedAt; // New field

  final List<Follower> followers;

  final ViewersResponse? viewersResponse;
  final MutedStoriesResponse? mutedStoriesResponse;

  final bool isLoadingFollower;
  final String? errorMessage;

  StoryState({
    this.mutedStoriesResponse,
    this.viewersResponse,
    required this.followers,
    this.isLoadingFollower = false,
    this.errorMessage,
    required this.users,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isFetchingMore = false,
    this.currentStoryCreatedAt, // Initialize the field
  });

  StoryState copyWith({
    MutedStoriesResponse? mutedStoriesResponse,
    ViewersResponse? viewersResponse,
    List<Follower>? followers,
    bool? isLoadingFollower,
    String? errorMessage,
    List<UserStories>? stories,
    bool? isLoading,
    bool? hasReachedMax,
    int? currentPage,
    bool? isFetchingMore,
    DateTime? currentStoryCreatedAt, // Include this in copyWith
  }) {
    return StoryState(
      mutedStoriesResponse: mutedStoriesResponse ?? this.mutedStoriesResponse,
      viewersResponse: viewersResponse ?? this.viewersResponse,
      currentStoryCreatedAt:
          currentStoryCreatedAt ?? this.currentStoryCreatedAt,
      // New copyWith field
      followers: followers ?? this.followers,
      isLoadingFollower: isLoadingFollower ?? this.isLoadingFollower,
      errorMessage: errorMessage,
      users: stories ?? users,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class StoryInitial extends StoryState {
  StoryInitial() : super(users: [], followers: []);
}

class StoryError extends StoryState {
  final String error;

  StoryError(this.error) : super(users: [], followers: []);
}

class StoryCubit extends Cubit<StoryState> {
  final StoryRepository storyRepository;
  final ApiConsumer apiConsumer;

  DateTime? _currentStoryCreatedAt; // Store the current story's createdAt

  StoryCubit(this.storyRepository, this.apiConsumer) : super(StoryInitial());

  makeView({storyId, context}) async {
    getViewersInStory(context: context, storyId: storyId);

    // Map<String, dynamic> data = {};

    final response = await apiConsumer
        .post('https://49dev.com/api/v1/stories/view/$storyId');

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
    Map<String, dynamic> data = {"muteUser": "$userId"};

    final response = await apiConsumer
        .post('https://49dev.com/api/v1/stories/muteUserStory', data: data);

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
  Future<void> getMutedStories({
    userId,
    context,
    limit = 1,
    page = 1,
    loadMore = false,
  }) async {
    try {
      // Make the API call
      final response = await apiConsumer.get(
          'https://49dev.com/api/v1/stories/mutedStories?limit=$limit&page=$page');

      response.fold(
        (failure) {
          // Handle failure (API error, network issue, etc.)
          print('Error fetching muted stories');
        },
        (data) {
          // Parse the response
          final newData = MutedStoriesResponse.fromJson(data);

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
    final response =
        await apiConsumer.get('https://49dev.com/api/v1/stories/view/$storyId');
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
                ViewersResponse.fromMap(data))); // Set loading state
      },
    );
  }

  /// Fetch all followers based on subCategory ID
  Future<void> fetchFollowers() async {
    try {
      emit(state.copyWith(isLoading: true)); // Set loading state

      final followers =
          await storyRepository.getAllFollowers('62ef7cf658c90d4a7ed48120');

      emit(state.copyWith(followers: followers, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: 'Failed to load followers'));
    }
  }

  // New method to update story privacy
  Future<void> updateStoryPrivacy(String privacyType,
      {List<String>? users}) async {
    try {
      emit(state.copyWith(isLoading: true)); // Show loading state

      await storyRepository.updatePrivacy(privacyType, users: users);

      // Optional: fetch stories again if you want to refresh the state after updating privacy
      await fetchStories();

      emit(state.copyWith(isLoading: false)); // Reset loading state
    } catch (e) {
      emit(StoryError('Failed to update privacy: $e'));
    }
  }

  Future<void> deleteStory(String storyId) async {
    try {
      emit(state.copyWith(isLoading: true));
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
      await fetchStories();
    } catch (e) {
      emit(StoryError('Failed to delete story: $e'));
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
              const Divider(thickness: 1, color: Colors.transparent),

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
