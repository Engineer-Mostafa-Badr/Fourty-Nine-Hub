import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:http/http.dart' as http;
import '../../data/models/tinder_person_model.dart';
import '../../data/models/tinder_subcategory_model.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  TinderViewCubit() : super(TinderViewState.initial());

  Future<void> fetchSubCategoryData() async {
    const url = 'https://49dev.com/api/v1/tinder/subCategories';
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> responseData = jsonResponse['data'];

      final subCategoryData = responseData
          .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
          .toList();
      emit(state.updated(subCategoryData: subCategoryData));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchUserData({String gender = 'female'}) async {
    final url = 'https://49dev.com/api/v1/tinder/?gender=$gender';
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final List<dynamic> responseData = jsonResponse['data'];
        final userData = responseData
            .map<UserData>((data) => UserData.fromJson(data))
            .toList();
        emit(state.updated(userData: userData));
      } else {
        log('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<void> uploadImages({required mediaIds}) async {
    const url = 'https://49dev.com/api/v1/tinder/uploadPictures';
    const token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjVkZDhlODgzLTQyNjMtNGNiOS1hNzgzLWY1NjAwMGMzZmJmOSIsImlhdCI6MTcyMjc3NDQ4MywiZXhwIjo1NTcyMjc3NDQ4Mywic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.MiK4rkOQQupy_SAkI2QwG7CwWMoSVWdmiOFB2XF4unw';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'medias': mediaIds,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Successfully uploaded
        print('Upload successful: ${response.body}');
      } else {
        // Handle other status codes
        print('Failed to upload: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Handle errors
      print('Error occurred: $e');
    }
  }

  // Future<void> fetchUserData() async {
  //   const url = 'https://49dev.com/api/v1/tinder/?gender=female';
  //   const token =
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';

  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);

  //     final List<dynamic> responseData = jsonResponse['data'];
  //     final userData = responseData
  //         .map<UserData>((data) => UserData.fromJson(data))
  //         .toList();
  //     emit(state.updated(userData: userData));
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  void updatePanStart(Offset startDragOffset) {
    emit(state.updated(startDragOffset: startDragOffset));
  }

  void updatePanUpdate(Offset position, double rotation) {
    emit(state.updated(position: position, rotation: rotation));
  }

  void resetPan() {
    emit(state.updated(position: Offset.zero, rotation: 0));
  }

  void swipeAway() {
    emit(state.updated(
        position: Offset(state.position.dx * 50, state.position.dy * 50)));
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(state.updated(
        currentIndex: (state.currentIndex + 1) % state.userData.length,
        currentStoryIndex: 0,
        position: Offset.zero,
        rotation: 0,
      ));
    });
  }

  void nextStory() {
    if (state.currentStoryIndex <
        state.userData[state.currentIndex].pictures.length - 1) {
      emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
    }
  }

  void previousStory() {
    if (state.currentStoryIndex > 0) {
      emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
    }
  }
}
