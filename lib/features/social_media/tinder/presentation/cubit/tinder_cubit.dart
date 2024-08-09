import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/send_gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/tinder_view.dart';
import 'package:http/http.dart' as http;
import '../../data/models/gift_model.dart';
import '../../data/models/tinder_person_model.dart';
import '../../data/models/tinder_subcategory_model.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  TinderViewCubit() : super(TinderViewState.initial());

  // static const token =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImIwODI3MjQ3LWRkMWMtNGU5YS05MWFhLTA0YjU3MGQ2NTgwMCIsImlhdCI6MTcyMzIwMDM3MSwiZXhwIjo1NTcyMzIwMDM3MSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.CAlB8Ne-HCyGy3qyBpVVHnO_-Gt607BPn-s-eLGKtAY';

  static const token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';

  Future<void> fetchLastSeen(String userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://49dev.com/api/v1/users/last-seen/$userId?status=online'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // 'Authorization':
          //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImYyZTM2M2M1LWJlNjctNDZkMi04MjMwLTI0NTE5MzBiYTcyNiIsImlhdCI6MTcyMzEyNDQ3NSwiZXhwIjo1NTcyMzEyNDQ3NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.jWU3AjoF2pCuw0QH_rgWU2A3lQ-aaaM9LIEMl7kBT7c',
        },
      );
      // log(response.body + '000000000000000000000000');
      if (response.statusCode == 200) {
        final lastSeenModel = LastSeenModel.fromJson(jsonDecode(response.body));

        // log('${lastSeenModel.data!.lastSeen}&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');

        emit(state.updated(lastSeenModel: lastSeenModel));
      } else {
        log('Failed to fetch last seen data ==================');
      }
    } catch (e) {
      log('An error occurred: $e');
    }
  }

  String handleResponse(String jsonResponse) {
    print("Raw JSON response: $jsonResponse"); // Debugging output

    // Check if the response is null or empty
    if (jsonResponse.isEmpty) {
      // showInsufficientFundsPopup(context, "No data received.");
      return "No data received.";
    }

    try {
      // Decode the JSON response
      Map<String, dynamic> response = json.decode(jsonResponse);

      if (response['success'] == false) {
        // Handle the error response
        String errorMessage =
            response['error']['message'] ?? "Unknown error occurred.";
        return errorMessage;
      } else if (response['status'] == true) {
        // Handle the success response
        String successMessage =
            response['message'] ?? "Gift sent successfully!";
        return successMessage;
      } else {
        return "Unexpected response format.";
      }
    } catch (e) {
      // Handle JSON decoding errors
      print("Error decoding JSON: $e");
      return "An error occurred while processing the response.";
    }
  }

  Future<String?> sendGift({
    required String receiverId,
    required String giftId,
    required String subCategoryId,
    required String currentUserToken,
    // required context,
  }) async {
    final String url =
        'https://49dev.com/api/v1/tinder/sendGifts?subCategory=$subCategoryId';

    final Map<String, dynamic> data = {
      "receiverId": receiverId,
      "giftId": giftId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token',
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImYyZTM2M2M1LWJlNjctNDZkMi04MjMwLTI0NTE5MzBiYTcyNiIsImlhdCI6MTcyMzEyNDQ3NSwiZXhwIjo1NTcyMzEyNDQ3NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.jWU3AjoF2pCuw0QH_rgWU2A3lQ-aaaM9LIEMl7kBT7c',
        },
        body: jsonEncode(data),
      );
      // log(response.body + '``````````````````````````````');
      // handleResponse(response.body);
      // // if(response.body.contains('"status":true'))
      // List<dynamic> successData = json.decode('[${response.body}]');
      // bool containsMessage = successData
      //     .any((item) => item['message'] == 'sent Gift Successfully');
      //
      // final sendGiftModel =
      //     SendGiftErrorData.fromJson(jsonDecode(response.body)['error']);
      // log(sendGiftModel.message.toString());
      // Update the state with the success response
      emit(state.updated(giftErrorData: SendGiftErrorData()));
      return response.body.toString();
    } catch (e) {
      log('Exception caught: $e');
      return 'error';
    }
    return null;
  }

  Future<List<GiftData>?> fetchGifts() async {
    try {
      final response = await http.get(
        Uri.parse('https://49dev.com/api/v1/dashboard-gifts'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final GiftApi giftApi = GiftApi.fromJson(jsonResponse);
        emit(state.updated(gifts: giftApi.data ?? []));

        log('${giftApi.data!.first.nameAr}0000000000000000');
        return giftApi.data;
      } else {
        log('Failed to load gifts');
      }
    } catch (e) {
      log('Error fetching gifts: $e');
    }
    return null;
  }

  Future<void> checkUserNearby({required String cardUserId}) async {
    String url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
    const String subCategory = '62c8be798e28a58a3edf5f63';

    try {
      final response = await http.get(
        Uri.parse('$url?subCategory=$subCategory'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImFmNDFjNDIwLTJjMzUtNGMyNi1iN2Y2LWZmMmNhOWJhYjMwZCIsImlhdCI6MTcyMzEwMTI0MSwiZXhwIjo1NTcyMzEwMTI0MSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.exA4sA5SRCUfRcaXT-BI1pLJ6Ck_YVTPXSK4wuFImX0',
        },
      );
      log(response.body.toString());

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        NearByModel nearbyModel = NearByModel.fromJson(jsonResponse);
        bool isNearby = nearbyModel.data?.isNearBy ?? false;
        log(jsonResponse.toString());

        emit(state.updated(isUserNearby: isNearby));
      } else {
        log('Failed to load data "checkUserNearby": ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  Future<void> fetchSubCategoryData() async {
    const url = 'https://49dev.com/api/v1/tinder/subCategories';

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
        log("$responseData;;;;;;;;;;;;;;;;;;;;;;;;;");

        final userData = responseData
            .map<UserData>((data) => UserData.fromJson(data))
            .toList();
        log("${userData.first.user!.firstName};;;;;;;;;;;;;;;;;;;;;;;;;");
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

  // Future<void> uploadImages({required mediaIds}) async {
  //   const url = 'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c',
  //   };
  //   final body = jsonEncode({
  //     'pictures': [mediaIds],
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Successfully uploaded
  //       log('Upload successful: ${response.body}');
  //     } else {
  //       // Handle other status codes
  //       log('Failed to upload: ${response.statusCode}, ${response.body}');
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     log('Error occurred: $e');
  //   }
  // }

  Future<void> uploadPictures(
      {required String token, required List<String> pictures}) async {
    final String url =
        'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'pictures': pictures,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Upload successful: ${response.body}');
      emit(state.updated());
    } else {
      // Handle error
      print('Failed to upload: ${response.statusCode} ${response.body}');
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
        state.userData[state.currentIndex].pictures!.length - 1) {
      emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
    }
  }

  void previousStory() {
    if (state.currentStoryIndex > 0) {
      emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
    }
  }
}
// // ............................................................
// // import 'dart:convert';
// // import 'dart:developer';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/send_gift_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// // import 'package:http/http.dart' as http;
// // import '../../data/models/gift_model.dart';
// // import '../../data/models/tinder_person_model.dart';
// // import '../../data/models/tinder_subcategory_model.dart';
// //
// // class TinderViewCubit extends Cubit<TinderViewState> {
// //   TinderViewCubit() : super(TinderViewState.initial());
// //
// //   static const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';
// //
// //   String handleResponse(String jsonResponse) {
// //     print("Raw JSON response: $jsonResponse"); // Debugging output
// //
// //     if (jsonResponse.isEmpty) {
// //       return "No data received.";
// //     }
// //
// //     try {
// //       Map response = json.decode(jsonResponse);
// //       if (response['success'] == false) {
// //         return response['error']['message'] ?? "Unknown error occurred.";
// //       } else if (response['status'] == true) {
// //         return response['message'] ?? "Gift sent successfully!";
// //       } else {
// //         return "Unexpected response format.";
// //       }
// //     } catch (e) {
// //       print("Error decoding JSON: $e");
// //       return "An error occurred while processing the response.";
// //     }
// //   }
// //
// //   Future<String?> sendGift({
// //     required String receiverId,
// //     required String giftId,
// //     required String subCategoryId,
// //     required String currentUserToken,
// //   }) async {
// //     final String url = 'https://49dev.com/api/v1/tinder/sendGifts?subCategory=$subCategoryId';
// //     final Map data = {
// //       "receiverId": receiverId,
// //       "giftId": giftId,
// //     };
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'Authorization': 'Bearer $token',
// //         },
// //         body: jsonEncode(data),
// //       );
// //
// //       emit(state.updated(giftErrorData: SendGiftErrorData()));
// //       return response.body.toString();
// //     } catch (e) {
// //       log('Exception caught: $e');
// //       return 'error';
// //     }
// //   }
// //
// //   Future<List<GiftData>?> fetchGifts() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('https://49dev.com/api/v1/dashboard-gifts'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final jsonResponse = json.decode(response.body);
// //         final GiftApi giftApi = GiftApi.fromJson(jsonResponse);
// //         emit(state.updated(gifts: giftApi.data ?? []));
// //         return giftApi.data;
// //       } else {
// //         log('Failed to load gifts');
// //       }
// //     } catch (e) {
// //       log('Error fetching gifts: $e');
// //     }
// //     return null;
// //   }
// //
// //   Future<void> checkUserNearby({required String cardUserId}) async {
// //     String url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
// //     const String subCategory = '62c8be798e28a58a3edf5f63';
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse('$url?subCategory=$subCategory'),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final Map<String,dynamic> jsonResponse = json.decode(response.body);
// //         NearByModel nearbyModel = NearByModel.fromJson(jsonResponse);
// //         bool isNearby = nearbyModel.data?.isNearBy ?? false;
// //         emit(state.updated(isUserNearby: isNearby));
// //       } else {
// //         log('Failed to load data "checkUserNearby": ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       log('Error: $e');
// //     }
// //   }
// //
// //   Future<void> fetchSubCategoryData() async {
// //     const url = 'https://49dev.com/api/v1/tinder/subCategories';
// //
// //     final response = await http.get(
// //       Uri.parse(url),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //       },
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final Map jsonResponse = json.decode(response.body);
// //       final List responseData = jsonResponse['data'];
// //       final subCategoryData = responseData.map((data) => SubCategoryData.fromJson(data)).toList();
// //       emit(state.updated(subCategoryData: subCategoryData));
// //     } else {
// //       throw Exception('Failed to load data');
// //     }
// //   }
// //
// //   Future<void> fetchUserData({String gender = 'female'}) async {
// //     final url = 'https://49dev.com/api/v1/tinder/?gender=$gender';
// //
// //     try {
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final Map jsonResponse = json.decode(response.body);
// //         final List responseData = jsonResponse['data'];
// //         final userData = responseData.map((data) => UserData.fromJson(data)).toList();
// //         emit(state.updated(userData: userData));
// //       } else {
// //         log('Failed to load data: ${response.statusCode}');
// //         throw Exception('Failed to load data');
// //       }
// //     } catch (e) {
// //       log('Error fetching data: $e');
// //       throw Exception('Failed to load data');
// //     }
// //   }
// //
// //   Future<void> uploadPictures({required String token, required List pictures}) async {
// //     final String url = 'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
// //
// //     final response = await http.post(
// //       Uri.parse(url),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //       body: jsonEncode({'pictures': pictures}),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       print('Upload successful: ${response.body}');
// //       emit(state.updated());
// //     } else {
// //       print('Failed to upload: ${response.statusCode} ${response.body}');
// //     }
// //   }
// //
// //   void updatePanStart(Offset startDragOffset) {
// //     emit(state.updated(startDragOffset: startDragOffset));
// //   }
// //
// //   void updatePanUpdate(Offset position, double rotation) {
// //     emit(state.updated(position: position, rotation: rotation));
// //   }
// //
// //   void resetPan() {
// //     emit(state.updated(position: Offset.zero, rotation: 0));
// //   }
// //
// //   void swipeAway() {
// //     emit(state.updated(position: Offset(state.position.dx * 50, state.position.dy * 50)));
// //     Future.delayed(const Duration(milliseconds: 300), () {
// //       emit(state.updated(
// //         currentIndex: (state.currentIndex + 1) % state.userData.length,
// //         currentStoryIndex: 0,
// //         position: Offset.zero,
// //         rotation: 0,
// //       ));
// //     });
// //   }
// //
// //   void nextStory() {
// //     if (state.currentStoryIndex < state.userData[state.currentIndex].pictures!.length - 1) {
// //       emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
// //     }
// //   }
// //
// //   void previousStory() {
// //     if (state.currentStoryIndex > 0) {
// //       emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
// //     }
// //   }
// }
