import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/stories/data/models/friends_stories_model.dart';
import 'package:fourtyninehub/features/social_media/stories/data/repositories/StoriesRpo.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import '../../../../../core/utils/shared_pref.dart';

class StoryState {
  List<UserStories> stories;
  final bool isLoading;
  final bool hasReachedMax;
  final int currentPage;
  final bool isFetchingMore;
  final DateTime? currentStoryCreatedAt; // New field

  StoryState({
    required this.stories,
    this.isLoading = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.isFetchingMore = false,
    this.currentStoryCreatedAt, // Initialize the field
  });

  StoryState copyWith({
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

      stories: stories ?? this.stories,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class StoryInitial extends StoryState {
  StoryInitial() : super(stories: []);
}

class StoryError extends StoryState {
  final String error;

  StoryError(this.error) : super(stories: []);
}

class StoryCubit extends Cubit<StoryState> {
  final StoryRepository storyRepository;
  DateTime? _currentStoryCreatedAt; // Store the current story's createdAt

  StoryCubit(this.storyRepository) : super(StoryInitial());

  Future<void> fetchStories({bool loadMore = false}) async {
    if ((loadMore && state.isFetchingMore) || (!loadMore && state.isLoading)) {
      return; // Prevent duplicate fetches
    }

    try {
      emit(state.copyWith(
        isLoading: !loadMore,
        isFetchingMore: loadMore,
      ));

      final listOfUserStories = await storyRepository.fetchStories(state.currentPage);

      if (listOfUserStories.isEmpty && loadMore) {
        // No more stories to load
        emit(state.copyWith(
          hasReachedMax: true,
          isLoading: false,
          isFetchingMore: false,
        ));
        return;
      }

      final newStories = loadMore
          ? [...state.stories, ...listOfUserStories]
          : listOfUserStories;

      // Remove duplicates using a Map where keys are story IDs
      final uniqueStoriesMap = {for (var story in newStories) story.user!.id: story};
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
