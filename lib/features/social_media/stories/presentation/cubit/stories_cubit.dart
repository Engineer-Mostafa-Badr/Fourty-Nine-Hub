import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  final bool isLoadingFollower;
  final String? errorMessage;

  StoryState({
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





  // updateRestaurant1(context, id) async {
  //   CreateRestaurantParams params = createRestaurantParams;
  //   _validationUpdateState();
  //
  //   // List<Map<String, dynamic>> mneu = [];
  //   // params.mneu?.forEach((element) {
  //   //   final toMap = {
  //   //     "foodName": element.foodName,
  //   //     "picture": element.photo,
  //   //     "price": element.price,
  //   //   };
  //   //   mneu.add(toMap);
  //   // });
  //   Map<String, dynamic> data = {
  //     "name": params.name,
  //     "phone": params.number,
  //     "subcategoryId": params.subcategoryId,
  //     "restaurantMedia": params.restaurantMedia,
  //     "licenseMedia": params.licenseMedia,
  //     "government": params.government,
  //     "city": params.city,
  //     // "menu": mneu,
  //   };
  //
  //   final response = await apiConsumer.put(
  //       'https://49dev.com/api/v1/restaurants/update-restaurant-info/$id',
  //       data: data);
  //
  //   return response.fold(
  //         (Failure failure) {
  //       print(data.toString() + "asfsdggvsdvbsdvzvzvzvfailure");
  //       showErrorMessage(context, getFailureMessage(failure, context));
  //       // ScaffoldMessenger.of(
  //       //         AppPages.router.routerDelegate.navigatorKey.currentContext!)
  //       //     .showSnackBar(SnackBar(
  //       //   content: Text(LocaleKeys.completeAllFields.tr()),
  //       //   backgroundColor: Colors.red,
  //       // ));
  //       return Left(failure);
  //     },
  //         (data1) {
  //       showSuccessMessage(context, data1['message']);
  //       Navigator.pop(context);
  //
  //       print(data1.toString() + "asfsdggvsdvbsdvzvzvzv");
  //
  //       return Right(data['status']);
  //     },
  //   );
  // }




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
    final token = await TokenManager.getAccessToken();

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
    final token = await TokenManager.getAccessToken();

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
      final token = await TokenManager.getAccessToken();

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
