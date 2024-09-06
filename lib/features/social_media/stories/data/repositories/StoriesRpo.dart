import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/utils/shared_pref.dart';
import '../models/friends_stories_model.dart';

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
    _token = await TokenManager.getAccessToken();
  }

  Future<void> _ensureTokenInitialized() async {
    _token ??= await TokenManager.getAccessToken();
  }
  Future<void> deleteStory(String storyId) async {
    await _ensureTokenInitialized();
    final response = await http.delete(
      Uri.parse("https://49dev.com/api/v1/stories/$storyId"),
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
      Uri.parse("https://49dev.com/api/v1/stories/explore?page=$page"),
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
          ? const TextStyle(color: Colors.white, fontSize: 20)
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
