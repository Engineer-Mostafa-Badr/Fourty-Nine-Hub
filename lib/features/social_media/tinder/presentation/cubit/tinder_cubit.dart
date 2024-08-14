// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/send_gift_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// import 'package:http/http.dart' as http;
// import '../../data/models/gift_model.dart';
// import '../../data/models/tinder_person_model.dart';
// import '../../data/models/tinder_subcategory_model.dart';
//
// class TinderViewCubit extends Cubit<TinderViewState> {
//   // final String? accessToken;
//
//   TinderViewCubit() : super(TinderViewState.initial());
//
//   // static const accessToken =
//   //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';
//
//   //
//   // static const accessToken =
//   //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';
//
//   // final GetTokensUseCase _getTokensUseCase;
//
//   // // Future<String?> getUserToken() async {
//   //   return _getTokensUseCase(const NoParams()).then((value) {
//   //     return value.fold((l) => null, (r) => r?.accessToken);
//   //   });
//   // }
//   //
//
//   Future<void> fetchLastSeen({String? userId, accessToken}) async {
//     // String? userToken = await getUserToken();
//
//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://49dev.com/api/v1/users/last-seen/$userId?status=online'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//           // 'Authorization':
//           //     'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6ImYyZTM2M2M1LWJlNjctNDZkMi04MjMwLTI0NTE5MzBiYTcyNiIsImlhdCI6MTcyMzEyNDQ3NSwiZXhwIjo1NTcyMzEyNDQ3NSwic3ViIjoiNjZhNDBmN2Q4OGRjMjJkY2RiZDE0MjQwIn0.jWU3AjoF2pCuw0QH_rgWU2A3lQ-aaaM9LIEMl7kBT7c',
//         },
//       );
//       // log(response.body + '000000000000000000000000');
//       if (response.statusCode == 200) {
//         final lastSeenModel = LastSeenModel.fromJson(jsonDecode(response.body));
//
//         // log('${lastSeenModel.data!.lastSeen}&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
//
//         emit(state.updated(lastSeenModel: lastSeenModel));
//       } else {
//         log('Failed to fetch last seen data ==================');
//       }
//     } catch (e) {
//       log('An error occurred: $e');
//     }
//   }
//
//   String handleResponse({String? jsonResponse, accessToken}) {
//     log("Raw JSON response: $jsonResponse"); // Debugging output
//
//     // Check if the response is null or empty
//     if (jsonResponse!.isEmpty) {
//       // showInsufficientFundsPopup(context, "No data received.");
//       return "No data received.";
//     }
//
//     try {
//       // Decode the JSON response
//       Map<String, dynamic> response = json.decode(jsonResponse);
//
//       if (response['success'] == false) {
//         // Handle the error response
//         String errorMessage =
//             response['error']['message'] ?? "Unknown error occurred.";
//         return errorMessage;
//       } else if (response['status'] == true) {
//         // Handle the success response
//         String successMessage =
//             response['message'] ?? "Gift sent successfully!";
//         return successMessage;
//       } else {
//         return "Unexpected response format.";
//       }
//     } catch (e) {
//       // Handle JSON decoding errors
//       log("Error decoding JSON: $e");
//       return "An error occurred while processing the response.";
//     }
//   }
//
//   Future<String?> sendGift(
//       {required String receiverId,
//       required String giftId,
//       required String subCategoryId,
//       required String currentUserToken,
//       accessToken
//       // required context,
//       }) async {
//     final String url =
//         'https://49dev.com/api/v1/tinder/sendGifts?subCategory=$subCategoryId';
//
//     final Map<String, dynamic> data = {
//       "receiverId": receiverId,
//       "giftId": giftId,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: jsonEncode(data),
//       );
//       // log(response.body + '``````````````````````````````');
//       // handleResponse(response.body);
//       // // if(response.body.contains('"status":true'))
//       // List<dynamic> successData = json.decode('[${response.body}]');
//       // bool containsMessage = successData
//       //     .any((item) => item['message'] == 'sent Gift Successfully');
//       //
//       // final sendGiftModel =
//       //     SendGiftErrorData.fromJson(jsonDecode(response.body)['error']);
//       // log(sendGiftModel.message.toString());
//       // Update the state with the success response
//       emit(state.updated(giftErrorData: SendGiftErrorData()));
//       return response.body.toString();
//     } catch (e) {
//       log('Exception caught: $e');
//       return 'error';
//     }
//   }
//
//   Future<List<GiftData>?> fetchGifts({accessToken}) async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://49dev.com/api/v1/dashboard-gifts'),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final GiftApi giftApi = GiftApi.fromJson(jsonResponse);
//         emit(state.updated(gifts: giftApi.data ?? []));
//
//         log('${giftApi.data!.first.nameAr}0000000000000000');
//         return giftApi.data;
//       } else {
//         log('Failed to load gifts');
//       }
//     } catch (e) {
//       log('Error fetching gifts: $e');
//     }
//     return null;
//   }
//
//   Future<void> checkUserNearby(
//       {required String cardUserId, accessToken}) async {
//     String url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
//     const String subCategory = '62c8be798e28a58a3edf5f63';
//
//     try {
//       final response = await http.get(
//         Uri.parse('$url?subCategory=$subCategory'),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//         },
//       );
//       log(response.body.toString());
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);
//         NearByModel nearbyModel = NearByModel.fromJson(jsonResponse);
//         bool isNearby = nearbyModel.data?.isNearBy ?? false;
//         log(jsonResponse.toString());
//
//         emit(state.updated(isUserNearby: isNearby));
//       } else {
//         log('Failed to load data "checkUserNearby": ${response.statusCode}');
//       }
//     } catch (e) {
//       log('Error: $e');
//     }
//   }
//
//   Future<void> fetchSubCategoryData({accessToken}) async {
//     const url = 'https://49dev.com/api/v1/tinder/subCategories';
//
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       final List<dynamic> responseData = jsonResponse['data'];
//
//       final subCategoryData = responseData
//           .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
//           .toList();
//       emit(state.updated(subCategoryData: subCategoryData));
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   Future<void> fetchUserData({String gender = 'female', accessToken}) async {
//     log(accessToken! + '88888888888888888888888888888888888');
//     final url = 'https://49dev.com/api/v1/tinder/?gender=$gender';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);
//
//         final List<dynamic> responseData = jsonResponse['data'];
//         log("$responseData;;;;;;;;;;;;;;;;;;;;;;;;;");
//
//         final userData = responseData
//             .map<UserData>((data) => UserData.fromJson(data))
//             .toList();
//         log("${userData.first.user!.firstName};;;;;;;;;;;;;;;;;;;;;;;;;");
//         emit(state.updated(userData: userData));
//       } else {
//         log('Failed to load data: ${response.statusCode}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       log('Error fetching data: $e');
//       throw Exception('Failed to load data');
//     }
//   }
//
//   // Future<void> uploadImages({required mediaIds}) async {
//   //   const url = 'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
//   //
//   //   final headers = {
//   //     'Content-Type': 'application/json',
//   //     'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c',
//   //   };
//   //   final body = jsonEncode({
//   //     'pictures': [mediaIds],
//   //   });
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: headers,
//   //       body: body,
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       // Successfully uploaded
//   //       log('Upload successful: ${response.body}');
//   //     } else {
//   //       // Handle other status codes
//   //       log('Failed to upload: ${response.statusCode}, ${response.body}');
//   //     }
//   //   } catch (e) {
//   //     // Handle errors
//   //     log('Error occurred: $e');
//   //   }
//   // }
//
//   Future<void> uploadPictures(
//       {required List<String> pictures, accessToken}) async {
//     const String url =
//         'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'pictures': pictures,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Handle success
//       log('Upload successful: ${response.body}');
//       emit(state.updated());
//     } else {
//       // Handle error
//       log('Failed to upload: ${response.statusCode} ${response.body}');
//     }
//   }
//
//   // Future<void> fetchUserData() async {
//   //   const url = 'https://49dev.com/api/v1/tinder/?gender=female';
//   //   const accessToken =
//   //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';
//
//   //   final response = await http.get(
//   //     Uri.parse(url),
//   //     headers: {
//   //       'Authorization': 'Bearer $accessToken',
//   //     },
//   //   );
//
//   //   if (response.statusCode == 200) {
//   //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
//
//   //     final List<dynamic> responseData = jsonResponse['data'];
//   //     final userData = responseData
//   //         .map<UserData>((data) => UserData.fromJson(data))
//   //         .toList();
//   //     emit(state.updated(userData: userData));
//   //   } else {
//   //     throw Exception('Failed to load data');
//   //   }
//   // }
//
//   void updatePanStart(Offset startDragOffset) {
//     emit(state.updated(startDragOffset: startDragOffset));
//   }
//
//   void updatePanUpdate(Offset position, double rotation) {
//     emit(state.updated(position: position, rotation: rotation));
//   }
//
//   void resetPan() {
//     emit(state.updated(position: Offset.zero, rotation: 0));
//   }
//
//   void swipeAway() {
//     emit(state.updated(
//         position: Offset(state.position.dx * 50, state.position.dy * 50)));
//     Future.delayed(const Duration(milliseconds: 300), () {
//       emit(state.updated(
//         currentIndex: (state.currentIndex + 1) % state.userData.length,
//         currentStoryIndex: 0,
//         position: Offset.zero,
//         rotation: 0,
//       ));
//     });
//   }
//
//   void nextStory() {
//     if (state.currentStoryIndex <
//         state.userData[state.currentIndex].pictures!.length - 1) {
//       emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
//     }
//   }
//
//   void previousStory() {
//     if (state.currentStoryIndex > 0) {
//       emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
//     }
//   }
// }
// // // ............................................................
// // // import 'dart:convert';
// // // import 'dart:developer';
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/data/models/send_gift_model.dart';
// // // import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_state.dart';
// // // import 'package:http/http.dart' as http;
// // // import '../../data/models/gift_model.dart';
// // // import '../../data/models/tinder_person_model.dart';
// // // import '../../data/models/tinder_subcategory_model.dart';
// // //
// // // class TinderViewCubit extends Cubit<TinderViewState> {
// // //   TinderViewCubit() : super(TinderViewState.initial());
// // //
// // //   static const accessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzb2NrZXRJZCI6IjAyYTlkZGY3LWI2NzItNGE1NC04NmJmLTE3MzQzM2M5NjYwZiIsImlhdCI6MTcyMjA5NjI5OSwiZXhwIjo1NTcyMjA5NjI5OSwic3ViIjoiNjZhNGUwNDQ1MzVlMThlNWMxZDcyMGM4In0.-xgk-lnnQP3t19LrwsNwBQN_TleJYPyX0N-soJeQA6c';
// // //
// // //   String handleResponse(String jsonResponse) {
// // //     log("Raw JSON response: $jsonResponse"); // Debugging output
// // //
// // //     if (jsonResponse.isEmpty) {
// // //       return "No data received.";
// // //     }
// // //
// // //     try {
// // //       Map response = json.decode(jsonResponse);
// // //       if (response['success'] == false) {
// // //         return response['error']['message'] ?? "Unknown error occurred.";
// // //       } else if (response['status'] == true) {
// // //         return response['message'] ?? "Gift sent successfully!";
// // //       } else {
// // //         return "Unexpected response format.";
// // //       }
// // //     } catch (e) {
// // //       log("Error decoding JSON: $e");
// // //       return "An error occurred while processing the response.";
// // //     }
// // //   }
// // //
// // //   Future<String?> sendGift({
// // //     required String receiverId,
// // //     required String giftId,
// // //     required String subCategoryId,
// // //     required String currentUserToken,
// // //   }) async {
// // //     final String url = 'https://49dev.com/api/v1/tinder/sendGifts?subCategory=$subCategoryId';
// // //     final Map data = {
// // //       "receiverId": receiverId,
// // //       "giftId": giftId,
// // //     };
// // //
// // //     try {
// // //       final response = await http.post(
// // //         Uri.parse(url),
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'Authorization': 'Bearer $accessToken',
// // //         },
// // //         body: jsonEncode(data),
// // //       );
// // //
// // //       emit(state.updated(giftErrorData: SendGiftErrorData()));
// // //       return response.body.toString();
// // //     } catch (e) {
// // //       log('Exception caught: $e');
// // //       return 'error';
// // //     }
// // //   }
// // //
// // //   Future<List<GiftData>?> fetchGifts() async {
// // //     try {
// // //       final response = await http.get(
// // //         Uri.parse('https://49dev.com/api/v1/dashboard-gifts'),
// // //         headers: {
// // //           'Authorization': 'Bearer $accessToken',
// // //         },
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         final jsonResponse = json.decode(response.body);
// // //         final GiftApi giftApi = GiftApi.fromJson(jsonResponse);
// // //         emit(state.updated(gifts: giftApi.data ?? []));
// // //         return giftApi.data;
// // //       } else {
// // //         log('Failed to load gifts');
// // //       }
// // //     } catch (e) {
// // //       log('Error fetching gifts: $e');
// // //     }
// // //     return null;
// // //   }
// // //
// // //   Future<void> checkUserNearby({required String cardUserId}) async {
// // //     String url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
// // //     const String subCategory = '62c8be798e28a58a3edf5f63';
// // //
// // //     try {
// // //       final response = await http.get(
// // //         Uri.parse('$url?subCategory=$subCategory'),
// // //         headers: {
// // //           'Authorization': 'Bearer $accessToken',
// // //         },
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         final Map<String,dynamic> jsonResponse = json.decode(response.body);
// // //         NearByModel nearbyModel = NearByModel.fromJson(jsonResponse);
// // //         bool isNearby = nearbyModel.data?.isNearBy ?? false;
// // //         emit(state.updated(isUserNearby: isNearby));
// // //       } else {
// // //         log('Failed to load data "checkUserNearby": ${response.statusCode}');
// // //       }
// // //     } catch (e) {
// // //       log('Error: $e');
// // //     }
// // //   }
// // //
// // //   Future<void> fetchSubCategoryData() async {
// // //     const url = 'https://49dev.com/api/v1/tinder/subCategories';
// // //
// // //     final response = await http.get(
// // //       Uri.parse(url),
// // //       headers: {
// // //         'Authorization': 'Bearer $accessToken',
// // //       },
// // //     );
// // //
// // //     if (response.statusCode == 200) {
// // //       final Map jsonResponse = json.decode(response.body);
// // //       final List responseData = jsonResponse['data'];
// // //       final subCategoryData = responseData.map((data) => SubCategoryData.fromJson(data)).toList();
// // //       emit(state.updated(subCategoryData: subCategoryData));
// // //     } else {
// // //       throw Exception('Failed to load data');
// // //     }
// // //   }
// // //
// // //   Future<void> fetchUserData({String gender = 'female'}) async {
// // //     final url = 'https://49dev.com/api/v1/tinder/?gender=$gender';
// // //
// // //     try {
// // //       final response = await http.get(
// // //         Uri.parse(url),
// // //         headers: {
// // //           'Authorization': 'Bearer $accessToken',
// // //         },
// // //       );
// // //
// // //       if (response.statusCode == 200) {
// // //         final Map jsonResponse = json.decode(response.body);
// // //         final List responseData = jsonResponse['data'];
// // //         final userData = responseData.map((data) => UserData.fromJson(data)).toList();
// // //         emit(state.updated(userData: userData));
// // //       } else {
// // //         log('Failed to load data: ${response.statusCode}');
// // //         throw Exception('Failed to load data');
// // //       }
// // //     } catch (e) {
// // //       log('Error fetching data: $e');
// // //       throw Exception('Failed to load data');
// // //     }
// // //   }
// // //
// // //   Future<void> uploadPictures({required String accessToken, required List pictures}) async {
// // //     final String url = 'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
// // //
// // //     final response = await http.post(
// // //       Uri.parse(url),
// // //       headers: {
// // //         'Authorization': 'Bearer $accessToken',
// // //         'Content-Type': 'application/json',
// // //       },
// // //       body: jsonEncode({'pictures': pictures}),
// // //     );
// // //
// // //     if (response.statusCode == 200) {
// // //       log('Upload successful: ${response.body}');
// // //       emit(state.updated());
// // //     } else {
// // //       log('Failed to upload: ${response.statusCode} ${response.body}');
// // //     }
// // //   }
// // //
// // //   void updatePanStart(Offset startDragOffset) {
// // //     emit(state.updated(startDragOffset: startDragOffset));
// // //   }
// // //
// // //   void updatePanUpdate(Offset position, double rotation) {
// // //     emit(state.updated(position: position, rotation: rotation));
// // //   }
// // //
// // //   void resetPan() {
// // //     emit(state.updated(position: Offset.zero, rotation: 0));
// // //   }
// // //
// // //   void swipeAway() {
// // //     emit(state.updated(position: Offset(state.position.dx * 50, state.position.dy * 50)));
// // //     Future.delayed(const Duration(milliseconds: 300), () {
// // //       emit(state.updated(
// // //         currentIndex: (state.currentIndex + 1) % state.userData.length,
// // //         currentStoryIndex: 0,
// // //         position: Offset.zero,
// // //         rotation: 0,
// // //       ));
// // //     });
// // //   }
// // //
// // //   void nextStory() {
// // //     if (state.currentStoryIndex < state.userData[state.currentIndex].pictures!.length - 1) {
// // //       emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
// // //     }
// // //   }
// // //
// // //   void previousStory() {
// // //     if (state.currentStoryIndex > 0) {
// // //       emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
// // //     }
// // //   }
// // }
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
//
// import '../../data/models/gift_model.dart';
// import '../../data/models/tinder_person_model.dart';
// import '../../data/models/tinder_subcategory_model.dart';
// import '../../data/models/last_seen_model.dart';
// import '../../data/models/near_by_model.dart';
// import '../../data/models/send_gift_model.dart';
// import 'tinder_state.dart';
//
// class TinderViewCubit extends Cubit<TinderViewState> {
//   TinderViewCubit() : super(TinderViewState.initial());
//
//   Future<void> fetchLastSeen(
//       {required String userId, required String accessToken}) async {
//     final response = await _makeGetRequest(
//       url: 'https://49dev.com/api/v1/users/last-seen/$userId?status=online',
//       accessToken: accessToken,
//     );
//
//     if (response != null) {
//       final lastSeenModel = LastSeenModel.fromJson(jsonDecode(response.body));
//       emit(state.updated(lastSeenModel: lastSeenModel));
//     }
//   }
//
//   String handleResponse({required String jsonResponse}) {
//     log("Raw JSON response: $jsonResponse");
//
//     if (jsonResponse.isEmpty) {
//       return "No data received.";
//     }
//
//     try {
//       final Map<String, dynamic> response = json.decode(jsonResponse);
//
//       if (response['success'] == false) {
//         return response['error']['message'] ?? "Unknown error occurred.";
//       } else if (response['status'] == true) {
//         return response['message'] ?? "Gift sent successfully!";
//       } else {
//         return "Unexpected response format.";
//       }
//     } catch (e) {
//       log("Error decoding JSON: $e");
//       return "An error occurred while processing the response.";
//     }
//   }
//
//   Future<String?> sendGift({
//     required String receiverId,
//     required String giftId,
//     required String subCategoryId,
//     required String accessToken,
//     required String currentUserToken,
//   }) async {
//     final String url =
//         'https://49dev.com/api/v1/tinder/sendGifts?subCategory=$subCategoryId';
//
//     final Map<String, dynamic> data = {
//       "receiverId": receiverId,
//       "giftId": giftId,
//     };
//
//     final response = await _makePostRequest(
//       url: url,
//       accessToken: accessToken,
//       body: jsonEncode(data),
//     );
//
//     if (response != null) {
//       emit(state.updated(
//           sendGiftErrorDataState: SendGiftErrorDataState.failure));
//       return response.body;
//     } else {
//       return 'error';
//     }
//   }
//
//   Future<List<GiftData>?> fetchGifts({required String accessToken}) async {
//     final response = await _makeGetRequest(
//       url: 'https://49dev.com/api/v1/dashboard-gifts',
//       accessToken: accessToken,
//     );
//
//     if (response != null) {
//       final giftApi = GiftApi.fromJson(jsonDecode(response.body));
//       emit(state.updated(gifts: giftApi.data ?? []));
//       return giftApi.data;
//     }
//     return null;
//   }
//
//   Future<void> checkUserNearby(
//       {required String cardUserId, required String accessToken}) async {
//     final String url =
//         'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
//     final String subCategory = '62c8be798e28a58a3edf5f63';
//
//     final response = await _makeGetRequest(
//       url: '$url?subCategory=$subCategory',
//       accessToken: accessToken,
//     );
//
//     if (response != null) {
//       final nearByModel = NearByModel.fromJson(jsonDecode(response.body));
//       final bool isNearby = nearByModel.data?.isNearBy ?? false;
//       emit(state.updated(isUserNearby: isNearby));
//     }
//   }
//
//   Future<void> fetchSubCategoryData({required String accessToken}) async {
//     final String url = 'https://49dev.com/api/v1/tinder/subCategories';
//
//     final response = await _makeGetRequest(
//       url: url,
//       accessToken: accessToken,
//     );
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       final subCategoryData = responseData
//           .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
//           .toList();
//       emit(state.updated(subCategoryData: subCategoryData));
//     }
//   }
//
//   Future<void> fetchUserData(
//       {required String gender, required String accessToken}) async {
//     emit(state.updated(userDataState: UserDataState.initial));
//
//     final String url =
//         'https://49dev.com/api/v1/tinder/?gender=$gender&page=1&limit=50&subCategory=66af974f8bf69f9469944746';
//
//     final response = await _makeGetRequest(
//       url: url,
//       accessToken: accessToken,
//     );
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       final userData = responseData
//           .map<UserData>((data) => UserData.fromJson(data))
//           .toList();
//       emit(state.updated(
//           userData: userData, userDataState: UserDataState.success));
//     } else {
//       emit(state.updated(userDataState: UserDataState.failure));
//     }
//   }
//
//   Future<void> uploadPictures({
//     required List<String> pictures,
//     required String accessToken,
//   }) async {
//     final String url =
//         'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
//
//     final response = await _makePostRequest(
//       url: url,
//       accessToken: accessToken,
//       body: jsonEncode({'pictures': pictures}),
//     );
//
//     if (response != null) {
//       log('Upload successful: ${response.body}');
//       emit(state.updated());
//     }
//   }
//
//   Future<http.Response?> _makeGetRequest(
//       {required String url, required String accessToken}) async {
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         return response;
//       } else {
//         log('Failed to load data: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       log('Error fetching data: $e');
//     }
//     return null;
//   }
//
//   Future<http.Response?> _makePostRequest({
//     required String url,
//     required String accessToken,
//     required String body,
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//
//       if (response.statusCode == 200) {
//         return response;
//       } else {
//         log('Failed to post data: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       log('Error posting data: $e');
//     }
//     return null;
//   }
//
//   // Pan and Story handling methods remain unchanged.
//   void updatePanStart(Offset startDragOffset) {
//     emit(state.updated(startDragOffset: startDragOffset));
//   }
//
//   void updatePanUpdate(Offset position, double rotation) {
//     emit(state.updated(position: position, rotation: rotation));
//   }
//
//   void resetPan() {
//     emit(state.updated(position: Offset.zero, rotation: 0));
//   }
//
//   void swipeAway() {
//     emit(state.updated(
//       position: Offset(state.position.dx * 50, state.position.dy * 50),
//     ));
//     Future.delayed(const Duration(milliseconds: 300), () {
//       emit(state.updated(
//         currentIndex: (state.currentIndex + 1) % state.userData.length,
//         currentStoryIndex: 0,
//         position: Offset.zero,
//         rotation: 0,
//       ));
//     });
//   }
//
//   void nextStory() {
//     if (state.currentStoryIndex <
//         state.userData[state.currentIndex].pictures!.length - 1) {
//       emit(state.updated(currentStoryIndex: state.currentStoryIndex + 1));
//     }
//   }
//
//   void previousStory() {
//     if (state.currentStoryIndex > 0) {
//       emit(state.updated(currentStoryIndex: state.currentStoryIndex - 1));
//     }
//   }
// }
//refactored
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/add_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/fav_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/tinder_shared_utils.dart';
import 'package:http/http.dart' as http;

import '../../data/models/gift_model.dart';
import '../../data/models/tinder_person_model.dart';
import '../../data/models/tinder_subcategory_model.dart';
import '../../data/models/last_seen_model.dart';
import '../../data/models/near_by_model.dart';
import 'tinder_state.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  TinderViewCubit() : super(TinderViewState.initial());

  // Future<void> uploadPictures(
  //     {required List<String> pictures, required String accessToken}) async {
  //   try {
  //     final uploadResult = await UploadFile().uploadImage(
  //       subCategoryId: '66af974f8bf69f9469944746',
  //       onUploaded: (uploadedFile) {
  //         context.read<TinderViewCubit>().uploadPictures(
  //           pictures: [uploadedFile.mediaId],
  //           accessToken: TinderSharedUtils.token,
  //         );
  //         log("${uploadedFile.file.path} uploaded successfully.-------------------");
  //       },
  //     );
  //     if (uploadResult == null) {
  //       log("Image upload failed: No file selected.");
  //     }
  //   } catch (e) {
  //     log("Image upload failed: $e");
  //   }
  // }

  Future<void> fetchUserProfile(
      {required String userId, required String token}) async {
    emit(state.copyWith(profileUserState: DataState.initial));
    try {
      final uri =
          // Uri.parse('https://49dev.com/api/v1/tinder/get-profile/$userId')
          Uri.parse('https://49dev.com/api/v1/tinder/get-profile/$userId')
              .replace(
                  queryParameters: {'subCategory': '66b2683f3a360fbdbf110767'});
      // queryParameters: {'subCategory': '66af974f8bf69f9469944746'});

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // log("${data}zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        final userModel = ProfileUserModel.fromJson(data);
        emit(state.copyWith(
            profileUserState: DataState.success,
            profileUserData: userModel.data));
        log("${userModel.data.userId.firstName} ${userModel.data.userId.lastName}sssssssssssssssssssssssssssssssssssszzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
        // return userModel;
      } else {
        emit(state.copyWith(profileUserState: DataState.failure));

        // emit(UserProfileError('Failed to load user profile'));
      }
    } catch (e) {
      emit(state.copyWith(profileUserState: DataState.failure));

      // emit(UserProfileError(e.toString()));
    }
    // return null;
  }

  Future<void> fetchFavorites(String accessToken) async {
    emit(state.copyWith(getFavCategoryListState: DataState.initial));

    const url = 'https://49dev.com/api/v1/favorite-sub-category';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // log("${response.body} id from  getFavCategoryModelState///////////");

      if (response.statusCode == 200) {
        // Parse the JSON response into the ApiResponse model
        final jsonResponse = json.decode(response.body);
        // log("${jsonResponse} //////id from  getFavCategoryModelState///////////");

        final apiResponse = SubFavoritesResponse.fromJson(jsonResponse);
        // log("${apiResponse.data
        //     .toString()} //////id from  getFavCategoryModelState///////////");

        // if (apiResponse.data != null && apiResponse.data!.favorites != null) {
        // apiResponse.data?.favorites!.forEach((element) {
        //   TinderSharedUtils.favListIds!.add(element.id!);
        //   log("${element.id} id from  getFavCategoryModelState///////////");
        // });

        // log("${apiResponse.success} id from  getFavCategoryModelState///////////");

        // for (var element in apiResponse.favorites) {
        //   log("${element.id} 2222222222222222222222222222222");
        // }
        log("${apiResponse.data.length} fetchFavorites success2222222222222222222222222222222");

        emit(state.copyWith(
            getFavCategoryListState: DataState.success,
            getFavCategoryList: apiResponse));
        // return apiResponse.data!.favorites;
        // emit(FavoriteCategorySuccess(apiResponse.data!.favorites!));
        // } else {
        //   emit(FavoriteCategoryFailure('No favorites found'));
        // emit(state.copyWith(getFavCategoryModelState: DataState.failure));
        // }
      } else {
        // Handle non-200 responses
        // emit(FavoriteCategoryFailure(
        //     'Failed to load favorites. Status code: ${response.statusCode}'));
        log("fetchFavorites fail 2222222222222222222222222222222");

        emit(state.copyWith(getFavCategoryListState: DataState.failure));
      }
    } catch (e) {
      // Handle errors
      // emit(FavoriteCategoryFailure('Error: $e'));
      log("fetchFavorites fail 2222222222222222222222222222222");

      emit(state.copyWith(getFavCategoryListState: DataState.failure));
      // log("${e}from  getFavCategoryModelState///////////");
    }
  }

  Future<void> addFavoriteCategory({accessToken, String? categoryId}) async {
    emit(state.copyWith(addCategoryModelState: DataState.initial));

    final url = 'https://49dev.com/api/v1/favorite-sub-category/$categoryId';
    // final url = 'https://49dev.com/api/v1/favorite-category/$categoryId';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response into AddCategoryModel
        final jsonResponse = json.decode(response.body);
        // final addCategoryModel = AddCategoryModel.fromJson(jsonResponse);
        log("${response.body}-==========================-=-090909099");
        emit(state.copyWith(addCategoryModelState: DataState.success));

        // emit(state.copyWith(
        //     addCategoryModelState: DataState.success,
        //     addCategoryModel: addCategoryModel));
        // log('${addCategoryModel.success}from addFavoriteCategory success///////////////////');
      } else {
        // Handle non-200 responses
        emit(state.copyWith(addCategoryModelState: DataState.failure));
      }
    } catch (e) {
      // Handle errors
      emit(state.copyWith(addCategoryModelState: DataState.failure));
      log("${e}from addFavoriteCategory method");
    }
  }

  // Future<FavoritesResponse?> fetchFavorites(
  //   String accessToken,
  // ) async {
  //   try {
  //     emit(state.copyWith(favoritesResponseState: DataState.initial));
  //
  //     // Replace with your actual API URL and token
  //     final response = await http.get(
  //       Uri.parse('https://49dev.com/api/v1/favorite-category'),
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final json = jsonDecode(response.body);
  //       final favoritesResponse = FavoritesResponse.fromJson(json);
  //       // emit(FavoritesLoaded(favoritesResponse));
  //       log('${favoritesResponse.data!.favorites!.first.categoryId!.nameAr}llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
  //       emit(state.copyWith(
  //           favoritesResponseState: DataState.success,
  //           favoritesResponse: favoritesResponse));
  //       return favoritesResponse;
  //     } else {
  //       // emit(state.copyWith(favoritesResponseState: DataState.failure));
  //     }
  //   } catch (e) {
  //     // emit(state.copyWith(favoritesResponseState: DataState.initial));
  //   }
  //   return null;
  // }

  Future<void> fetchLastSeen({
    required String userId,
    required String accessToken,
  }) async {
    final response = await _makeGetRequest(
        url: 'https://49dev.com/api/v1/users/last-seen/$userId?status=online',
        accessToken: accessToken,
        fromMethod: 'fetchLastSeen');
    log("${response!.body} response from fetchLastSeen ");
    try {
      final lastSeenModel = LastSeenModel.fromJson(jsonDecode(response.body));
      emit(state.copyWith(
          lastSeenModel: lastSeenModel, lastSeenModelState: DataState.success));
    } catch (e) {
      emit(state.copyWith(lastSeenModelState: DataState.failure));

      log("$e -------- fetchLastSeen");
    }
  }

  String handleResponse({required String jsonResponse}) {
    log("Raw JSON response: $jsonResponse");

    if (jsonResponse.isEmpty) {
      return "No data received.";
    }

    try {
      final Map<String, dynamic> response = json.decode(jsonResponse);

      if (response['success'] == false) {
        return response['error']['message'] ?? "Unknown error occurred.";
      } else if (response['status'] == true) {
        return response['message'] ?? "Gift sent successfully!";
      } else {
        return "Unexpected response format.";
      }
    } catch (e) {
      log("Error decoding JSON: $e");
      return "An error occurred while processing the response.";
    }
  }

  Future<String?> sendGift({
    required String receiverId,
    required String giftId,
    required String subCategoryId,
    required String accessToken,
  }) async {
    const url =
        'https://49dev.com/api/v1/tinder/sendGifts?subCategory=66af974f8bf69f9469944746';
    final data = {
      "receiverId": receiverId,
      "giftId": giftId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      return response.body;
    } catch (e) {
      log('Error posting data: $e');
    }
    return null;
    //
    // final response = await _makePostRequest(
    //   url: url,
    //   accessToken: accessToken,
    //   body: jsonEncode(data),
    // );
    //
    // if (response != null) {
    //   emit(state.copyWith(
    //       sendGiftErrorDataState: DataState.failure,
    //       sendGiftErrorData: response.body));
    //   return response.body;
    // } else {
    //   return 'error';
    // }
  }

  Future<List<GiftData>?> fetchGifts({required String accessToken}) async {
    final response = await _makeGetRequest(
        url: 'https://49dev.com/api/v1/dashboard-gifts?limit=10',
        accessToken: accessToken,
        fromMethod: 'fetchGifts');

    // log('${response!.body}giftApi111111111111111111111111');

    final giftApi = GiftApi.fromJson(jsonDecode(response!.body));
    log('${giftApi.data!.first.nameEn!}giftApi111111111111111111111111');
    emit(state.copyWith(gifts: giftApi.data ?? []));
    return giftApi.data;
    return null;
  }

  Future<void> checkUserNearby({
    required String cardUserId,
    required String accessToken,
  }) async {
    // final url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
    // final url =
    //     'https://49dev.com/api/v1/tinder/check-distance/66a40f0d88dc22dcdbd14202?subCategory=66af974f8bf69f9469944746';
    // const subCategory = '62c8be798e28a58a3edf5f63';

    final response = await _makeGetRequest(
        url:
            'https://49dev.com/api/v1/tinder/check-distance/$cardUserId?subCategory=66af974f8bf69f9469944746',
        accessToken: accessToken,
        fromMethod: 'checkUserNearby');
    
    try {
      log("${response!.body } 7777777777777777777777777777777777");

      final nearByModel = NearByModel.fromJson(jsonDecode(response.body));
      // final isNearby = nearByModel.data?.isNearBy;
      log("${nearByModel}777777777777777777777");
      emit(state.copyWith(
          isUserNearby: nearByModel, isUserNearbyState: DataState.success));
    }catch(e){
      log(e.toString()+" nearByModel faild ");
      emit(state.copyWith(isUserNearbyState: DataState.failure,isUserNearby: NearByModel()));

    }
  }

  Future<void> fetchSubCategoryData({required String accessToken}) async {
    const url = 'https://49dev.com/api/v1/tinder/subCategories';

    final response = await _makeGetRequest(
        url: url, accessToken: accessToken, fromMethod: 'fetchSubCategoryData');

    if (response != null) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      final subCategoryData = responseData
          .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
          .toList();
      emit(state.copyWith(subCategoryData: subCategoryData));
    }
  }
  Future<void> fetchUserData2({
    required String gender,
    required String accessToken,
    required int page,
  }) async {
    emit(state.copyWith(userDataState: DataState.initial));

    final url =
        'https://49dev.com/api/v1/tinder/?gender=$gender&page=$page&limit=20&subCategory=66af974f8bf69f9469944746';

    final response = await _makeGetRequest(
        url: url, accessToken: accessToken, fromMethod: 'fetchUserData');

    if (response != null) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      final userData = responseData
          .map<UserData>((data) => UserData.fromJson(data))
          .toList();

      final updatedUserData = List<UserData>.from(state.userData)..addAll(userData);

      emit(state.copyWith(
        userData: updatedUserData,
        userDataState: DataState.success,
      ));
    } else {
      emit(state.copyWith(userDataState: DataState.failure));
    }
  }

  Future<void> fetchUserData({
    required String gender,
    required String accessToken,
  }) async {
    emit(state.copyWith(userDataState: DataState.initial,userData: []));

    final url =
        'https://49dev.com/api/v1/tinder/?gender=$gender&page=1&limit=20&subCategory=66af974f8bf69f9469944746';
    // 'https://49dev.com/api/v1/tinder/?gender=$gender&page=1&limit=50&subCategory=66af974f8bf69f9469944746';

    final response = await _makeGetRequest(
        url: url, accessToken: accessToken, fromMethod: 'fetchUserData');

    if (response != null) {
      final List<dynamic> responseData = jsonDecode(response.body)['data'];
      final userData = responseData
          .map<UserData>((data) => UserData.fromJson(data))
          .toList();
      emit(
          state.copyWith(userData: userData, userDataState: DataState.success));
    } else {
      emit(state.copyWith(userDataState: DataState.failure,userData: []));
    }
  }

  Future<void> uploadPictures({
    required List<String> pictures,
    required String accessToken,
  }) async {
    emit(state.copyWith(uploadImageState: DataState.initial));

    const url =
        'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';

    final response = await _makePostRequest(
      url: url,
      accessToken: accessToken,
      body: jsonEncode({'pictures': pictures}),
    );
    emit(state.copyWith(uploadImageState: DataState.initial));

    if (response != null) {
      log('Upload successful: ${response.body}');
      emit(state.copyWith(uploadImageState: DataState.success));
    }
  }

  Future<http.Response?> _makeGetRequest({
    required String url,
    required String accessToken,
    required String fromMethod,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        log('Failed to load data from -----$fromMethod -------------: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
    return null;
  }

  Future<http.Response?> _makePostRequest({
    required String url,
    required String accessToken,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        log('Failed to post data: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      log('Error posting data: $e');
    }
    return null;
  }

  // Pan and Story handling methods
  void updatePanStart(Offset startDragOffset) {
    emit(state.copyWith(startDragOffset: startDragOffset));
  }

  void updatePanUpdate(Offset position, double rotation) {
    emit(state.copyWith(position: position, rotation: rotation));
  }

  void resetPan() {
    emit(state.copyWith(position: Offset.zero, rotation: 0));
  }

  void swipeAway() {
    emit(state.copyWith(
      position: Offset(state.position.dx * 50, state.position.dy * 50),
    ));
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(state.copyWith(
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
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex + 1));
    }
  }
  // void nextStory() {
  //   final newIndex = (state.currentUserIndex + 1) % state.userData.length;
  //   updateCurrentIndex(newIndex);
  // }

  void previousStory() {
    if (state.currentStoryIndex > 0) {
      emit(state.copyWith(currentStoryIndex: state.currentStoryIndex - 1));
    }
  }

  void updateCurrentIndex(int newIndex) {
    emit(state.copyWith(currentIndex: newIndex));
  }

  void resetStoryIndex() {
    emit(state.copyWith(currentStoryIndex: 0));
  }
}
