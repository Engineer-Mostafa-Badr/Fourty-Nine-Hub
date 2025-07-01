import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/utils/shared_pref.dart';
import '../models/followers_model.dart';
import '../models/friends_stories_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum StoryType { text, image, video }

class StoryData {
  final StoryType type;
  final String content;
  final String? caption;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  StoryData({
    required this.type,
    required this.content,
    this.caption,
    this.backgroundColor,
    this.textStyle,
  });
}

class StoryRepository {
  String? _token;

  StoryRepository() {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    _token = await CacheManager.getAccessToken();
  }

  Future<void> _ensureTokenInitialized() async {
    _token ??= await CacheManager.getAccessToken();
  }

  //-----------------------------------------------------------------------------------------------
  /// Fetch all followers using the provided API endpoint
  Future<List<Follower>> getAllFollowers(String subCategory) async {
    await _ensureTokenInitialized(); // Ensure token is initialized

    final url = Uri.parse(
        'https://1220-41-239-172-48.ngrok-free.app/api/v1/follow/followers?subCategory=$subCategory');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final responseModel = ResponseModel.fromJson(jsonResponse);

      // Return followers list
      return responseModel.data.followers;
    } else {
      throw Exception('Failed to load followers');
    }
  }

  //-----------------------------------------------------------------------------------------------

  // New method to update privacy
  Future<void> updatePrivacy(String privacyType, {List<String>? users}) async {
    await _ensureTokenInitialized(); // Ensure the token is available

    final url = Uri.parse('https://1220-41-239-172-48.ngrok-free.app/api/v1/stories/privacy');
    final headers = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'application/json',
    };

    // Build the request body
    Map<String, dynamic> body = {
      'privacyType': privacyType,
      'users': users,
    };

    // Include users if privacyType is 'except' or 'only-with'
    // if (privacyType == 'except' || privacyType == 'only-with') {
    //   body['users'] = users;
    // }

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        log('Privacy updated successfully --> ${response.body}');
      } else {
        log('Failed to update privacy: ${response.body}');
        throw Exception('Failed to update privacy');
      }
    } catch (e) {
      log('Error updating privacy: $e');
      throw Exception('Error updating privacy: $e');
    }
  }

  //-----------------------------------------------------------------------------------------------
  Future<void> deleteStory(String storyId) async {
    await _ensureTokenInitialized();
    final response = await http.delete(
      Uri.parse("https://1220-41-239-172-48.ngrok-free.app/api/v1/stories/$storyId"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );
    log('Story deleted successfully!${response.body} ***********************************************************************************');

    if (response.statusCode == 200) {
      log('Story deleted successfully! ***********************************************************************************');
    } else {
      throw Exception("Failed to delete story");
    }
  }

  Future<List<UserStories>> fetchStories(int page) async {
    await _ensureTokenInitialized();
    log("Fetching stories with token: $_token");

    final response = await http.get(
      Uri.parse("https://1220-41-239-172-48.ngrok-free.app/api/v1/stories/explore?page=$page"),
      headers: {
        "Authorization": "Bearer $_token",
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      log("Stories response: $jsonResponse ************************************************************************************** ************************************************************************************** ************************************************************************************** ************************************************************************************** ************************************************************************************** ************************************************************************************** **************************************************************************************");

      final storiesResponse = StoriesResponse.fromJson(jsonResponse);
      if (storiesResponse.data?.userStories != null) {
        return storiesResponse.data!.userStories!;
        // .expand((userStory) => userStory.stories!)
        // .map((story) => _mapStoryToStoryData(story))
        // .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load stories");
    }
  }

  StoryData _mapStoryToStoryData(Story story) {
    final StoryType type = _mapStringToStoryType(story.type!);
    return StoryData(
      type: type,
      content: story.content!,
      caption: story.caption,
      backgroundColor: type == StoryType.text ? Colors.black : null,
      textStyle: type == StoryType.text
          ? TextStyle(color: Colors.white, fontSize: 20.sp)
          : null,
    );
  }

  StoryType _mapStringToStoryType(String type) {
    switch (type) {
      case 'text':
        return StoryType.text;
      case 'image':
        return StoryType.image;
      case 'video':
        return StoryType.video;
      default:
        throw Exception("Unknown story type");
    }
  }
}
