// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/anonymous_chat_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/main_category_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/normal_chat_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:http/http.dart' as http;
//
// import '../../data/models/gift_model.dart';
// import '../../data/models/tinder_person_model.dart';
// import '../../data/models/tinder_subcategory_model.dart';
// import '../../data/models/last_seen_model.dart';
// import '../../data/models/near_by_model.dart';
// import 'tinder_state.dart';
//
// class TinderViewCubit extends Cubit<TinderViewState> {
//   TinderViewCubit() : super(TinderViewState.initial());
//
//   final String token = serviceLocator<UserCubit>().token ?? '';
//
//   Future<void> fetchMainCategoryById(String id) async {
//     emit(state.copyWith(mainCategoryResponseState: DataState.initial));
//     final url = 'https://49dev.com/api/v1/categories/main/$id';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final mainCategoryResponse = MainCategoryResponse.fromJson(data);
//         log(mainCategoryResponse.data.mainCategory.nameEn.toString() +
//             "[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[");
//
//         emit(state.copyWith(
//             mainCategoryResponseState: DataState.success,
//             mainCategoryResponse: mainCategoryResponse));
//       } else {
//         emit(state.copyWith(mainCategoryResponseState: DataState.failure));
//       }
//     } catch (e) {
//       emit(state.copyWith(mainCategoryResponseState: DataState.failure));
//     }
//   }
//
//   Future<bool> startNormalChat({
//     required String receiverId,
//     required String subCategoryId,
//   }) async {
//     emit(state.copyWith(normalChatResponseState: DataState.initial));
//     final url =
//         'https://49dev.com/api/v1/chat/start-chat/$receiverId?categoryId=$subCategoryId';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final normalChatModel = NormalChatResponse.fromJson(data);
//         log("${response.body}from startNormalChat cubit method ....");
//
//         // final chatId = data['_id']; // Assuming the API response contains an `_id` field for chatId
//
//         emit(state.copyWith(
//             normalChatResponse: normalChatModel,
//             normalChatResponseState: DataState.success));
//         return true;
//       } else {
//         emit(state.copyWith(normalChatResponseState: DataState.failure));
//         return false;
//       }
//     } catch (e) {
//       emit(state.copyWith(normalChatResponseState: DataState.failure));
//       return false;
//     }
//   }
//
//   // Future<String?> startNormalChat({
//   //   required String receiverId,
//   //   required String subCategoryId,
//   //   required String accessToken,
//   // }) async {
//   //   final url =
//   //       'https://49dev.com/api/v1/chat/start-chat/$receiverId?categoryId=62c8be6f8e28a58a3edf5f4f';
//   //   final data = {
//   //     "receiverId": receiverId,
//   //     // "giftId": giftId,
//   //   };
//   //
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse(url),
//   //       headers: {
//   //         'Authorization': 'Bearer $accessToken',
//   //         'Content-Type': 'application/json',
//   //       },
//   //       body: jsonEncode(data),
//   //     );
//   //
//   //     return response.body;
//   //   } catch (e) {
//   //     log('Error posting data: $e');
//   //   }
//   //   return null;
//   //   //
//   //   // final response = await _makePostRequest(
//   //   //   url: url,
//   //   //   accessToken: accessToken,
//   //   //   body: jsonEncode(data),
//   //   // );
//   //   //
//   //   // if (response != null) {
//   //   //   emit(state.copyWith(
//   //   //       sendGiftErrorDataState: DataState.failure,
//   //   //       sendGiftErrorData: response.body));
//   //   //   return response.body;
//   //   // } else {
//   //   //   return 'error';
//   //   // }
//   // }
//
//   Future<bool> startAnonymousChat({
//     required String receiverId,
//   }) async {
//     emit(state.copyWith(anonymousChatResponseState: DataState.initial));
//     final url =
//         'https://49dev.com/api/v1/chat/start-anonymous-chat/$receiverId';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         final anonymousChatModel = AnonymousChatResponse.fromJson(data);
//         log("${response.body}from startSecret Chat cubit method ....");
//
//         // final chatId = data['_id']; // Assuming the API response contains an `_id` field for chatId
//
//         emit(state.copyWith(
//             anonymousChatResponse: anonymousChatModel,
//             anonymousChatResponseState: DataState.success));
//         return true;
//       } else {
//         emit(state.copyWith(anonymousChatResponseState: DataState.failure));
//         return false;
//       }
//     } catch (e) {
//       emit(state.copyWith(anonymousChatResponseState: DataState.failure));
//       return false;
//     }
//   }
//
//   Future<void> fetchUserProfile({required String userId}) async {
//     emit(state.copyWith(profileUserState: DataState.initial));
//     try {
//       final uri =
//           // Uri.parse('https://49dev.com/api/v1/tinder/get-profile/$userId')
//           Uri.parse('https://49dev.com/api/v1/tinder/get-profile/$userId')
//               .replace(
//                   queryParameters: {'subCategory': '66b2683f3a360fbdbf110767'});
//       // queryParameters: {'subCategory': '66af974f8bf69f9469944746'});
//
//       final response = await http.get(
//         uri,
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // log("${data}zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
//         final userModel = ProfileUserModel.fromJson(data);
//         emit(state.copyWith(
//             profileUserState: DataState.success,
//             profileUserData: userModel.data));
//         log("${userModel.data.userId.firstName} ${userModel.data.userId.lastName}sssssssssssssssssssssssssssssssssssszzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
//         // return userModel;
//       } else {
//         emit(state.copyWith(profileUserState: DataState.failure));
//
//         // emit(UserProfileError('Failed to load user profile'));
//       }
//     } catch (e) {
//       emit(state.copyWith(profileUserState: DataState.failure));
//
//       // emit(UserProfileError(e.toString()));
//     }
//     // return null;
//   }
//
//   Future<void> fetchFavorites() async {
//     emit(state.copyWith(getFavCategoryListState: DataState.initial));
//
//     const url = 'https://49dev.com/api/v1/favorite-sub-category';
//
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       // log("${response.body} id from  getFavCategoryModelState///////////");
//
//       if (response.statusCode == 200) {
//         // Parse the JSON response into the ApiResponse model
//         final jsonResponse = json.decode(response.body);
//         // log("${jsonResponse} //////id from  getFavCategoryModelState///////////");
//
//         final apiResponse = SubFavoritesResponse.fromJson(jsonResponse);
//         // log("${apiResponse.data
//         //     .toString()} //////id from  getFavCategoryModelState///////////");
//
//         // if (apiResponse.data != null && apiResponse.data!.favorites != null) {
//         // apiResponse.data?.favorites!.forEach((element) {
//         //   TinderSharedUtils.favListIds!.add(element.id!);
//         //   log("${element.id} id from  getFavCategoryModelState///////////");
//         // });
//
//         // log("${apiResponse.success} id from  getFavCategoryModelState///////////");
//
//         // for (var element in apiResponse.favorites) {
//         //   log("${element.id} 2222222222222222222222222222222");
//         // }
//         log("${apiResponse.data.first.subCategoryId.picture} fetchFavorites success2222222222222222222222222222222");
//
//         emit(state.copyWith(
//             getFavCategoryListState: DataState.success,
//             getFavCategoryList: apiResponse));
//         // return apiResponse.data!.favorites;
//         // emit(FavoriteCategorySuccess(apiResponse.data!.favorites!));
//         // } else {
//         //   emit(FavoriteCategoryFailure('No favorites found'));
//         // emit(state.copyWith(getFavCategoryModelState: DataState.failure));
//         // }
//       } else {
//         // Handle non-200 responses
//         // emit(FavoriteCategoryFailure(
//         //     'Failed to load favorites. Status code: ${response.statusCode}'));
//         log("fetchFavorites fail 2222222222222222222222222222222");
//
//         emit(state.copyWith(getFavCategoryListState: DataState.failure));
//       }
//     } catch (e) {
//       // Handle errors
//       // emit(FavoriteCategoryFailure('Error: $e'));
//       log("fetchFavorites fail 2222222222222222222222222222222");
//
//       emit(state.copyWith(getFavCategoryListState: DataState.failure));
//       // log("${e}from  getFavCategoryModelState///////////");
//     }
//   }
//
//   Future<void> addFavoriteCategory({String? categoryId}) async {
//     emit(state.copyWith(addCategoryModelState: DataState.initial));
//
//     final url = 'https://49dev.com/api/v1/favorite-sub-category/$categoryId';
//     // final url = 'https://49dev.com/api/v1/favorite-category/$categoryId';
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         // Parse the JSON response into AddCategoryModel
//         // final jsonResponse = json.decode(response.body);
//         // final addCategoryModel = AddCategoryModel.fromJson(jsonResponse);
//         log("${response.body}-==========================-=-090909099");
//         emit(state.copyWith(addCategoryModelState: DataState.success));
//
//         // emit(state.copyWith(
//         //     addCategoryModelState: DataState.success,
//         //     addCategoryModel: addCategoryModel));
//         // log('${addCategoryModel.success}from addFavoriteCategory success///////////////////');
//       } else {
//         // Handle non-200 responses
//         emit(state.copyWith(addCategoryModelState: DataState.failure));
//       }
//     } catch (e) {
//       // Handle errors
//       emit(state.copyWith(addCategoryModelState: DataState.failure));
//       log("${e}from addFavoriteCategory method");
//     }
//   }
//
//   // Future<FavoritesResponse?> fetchFavorites(
//   //   String accessToken,
//   // ) async {
//   //   try {
//   //     emit(state.copyWith(favoritesResponseState: DataState.initial));
//   //
//   //     // Replace with your actual API URL and token
//   //     final response = await http.get(
//   //       Uri.parse('https://49dev.com/api/v1/favorite-category'),
//   //       headers: {
//   //         'Authorization': 'Bearer $accessToken',
//   //       },
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       final json = jsonDecode(response.body);
//   //       final favoritesResponse = FavoritesResponse.fromJson(json);
//   //       // emit(FavoritesLoaded(favoritesResponse));
//   //       log('${favoritesResponse.data!.favorites!.first.categoryId!.nameAr}llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll');
//   //       emit(state.copyWith(
//   //           favoritesResponseState: DataState.success,
//   //           favoritesResponse: favoritesResponse));
//   //       return favoritesResponse;
//   //     } else {
//   //       // emit(state.copyWith(favoritesResponseState: DataState.failure));
//   //     }
//   //   } catch (e) {
//   //     // emit(state.copyWith(favoritesResponseState: DataState.initial));
//   //   }
//   //   return null;
//   // }
//
//   Future<void> fetchLastSeen({
//     required String userId,
//   }) async {
//     final response = await _makeGetRequest(
//         url: 'https://49dev.com/api/v1/users/last-seen/$userId?status=online',
//         accessToken: token,
//         fromMethod: 'fetchLastSeen');
//     log("${response!.body} response from fetchLastSeen ");
//     try {
//       final lastSeenModel = LastSeenModel.fromJson(jsonDecode(response.body));
//       emit(state.copyWith(
//           lastSeenModel: lastSeenModel, lastSeenModelState: DataState.success));
//     } catch (e) {
//       emit(state.copyWith(lastSeenModelState: DataState.failure));
//
//       log("$e -------- fetchLastSeen");
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
//   }) async {
//     const url =
//         'https://49dev.com/api/v1/tinder/sendGifts?subCategory=66af974f8bf69f9469944746';
//     final data = {
//       "receiverId": receiverId,
//       "giftId": giftId,
//     };
//
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(data),
//       );
//
//       log(response.body);
//       return response.body;
//     } catch (e) {
//       log('Error posting data: $e');
//     }
//     return null;
//     //
//     // final response = await _makePostRequest(
//     //   url: url,
//     //   accessToken: accessToken,
//     //   body: jsonEncode(data),
//     // );
//     //
//     // if (response != null) {
//     //   emit(state.copyWith(
//     //       sendGiftErrorDataState: DataState.failure,
//     //       sendGiftErrorData: response.body));
//     //   return response.body;
//     // } else {
//     //   return 'error';
//     // }
//   }
//
//   Future<List<GiftData>?> fetchGifts() async {
//     final response = await _makeGetRequest(
//         url: 'https://49dev.com/api/v1/dashboard-gifts?limit=10',
//         accessToken: token,
//         fromMethod: 'fetchGifts');
//
//     // log('${response!.body}giftApi111111111111111111111111');
//
//     final giftApi = GiftApi.fromJson(jsonDecode(response!.body));
//     log('${giftApi.data!.first.nameEn!}giftApi111111111111111111111111');
//     emit(state.copyWith(gifts: giftApi.data ?? []));
//     return giftApi.data;
//   }
//
//   Future<void> checkUserNearby({
//     required String cardUserId,
//   }) async {
//     // final url = 'https://49dev.com/api/v1/tinder/check-distance/$cardUserId';
//     // final url =
//     //     'https://49dev.com/api/v1/tinder/check-distance/66a40f0d88dc22dcdbd14202?subCategory=66af974f8bf69f9469944746';
//     // const subCategory = '62c8be798e28a58a3edf5f63';
//
//     final response = await _makeGetRequest(
//         url:
//             'https://49dev.com/api/v1/tinder/check-distance/$cardUserId?subCategory=66af974f8bf69f9469944746',
//         accessToken: token,
//         fromMethod: 'checkUserNearby');
//
//     try {
//       log("${response!.body} 7777777777777777777777777777777777");
//
//       final nearByModel = NearByModel.fromJson(jsonDecode(response.body));
//       // final isNearby = nearByModel.data?.isNearBy;
//       log("${nearByModel}777777777777777777777");
//       emit(state.copyWith(
//           isUserNearby: nearByModel, isUserNearbyState: DataState.success));
//     } catch (e) {
//       log("$e nearByModel faild ");
//       emit(state.copyWith(
//           isUserNearbyState: DataState.failure, isUserNearby: NearByModel()));
//     }
//   }
//
//   Future<void> fetchSubCategoryData() async {
//     const url = 'https://49dev.com/api/v1/tinder/subCategories';
//
//     final response = await _makeGetRequest(
//         url: url, accessToken: token, fromMethod: 'fetchSubCategoryData');
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       final subCategoryData = responseData
//           .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
//           .toList();
//       emit(state.copyWith(subCategoryData: subCategoryData));
//     }
//   }
//
//   Future<void> fetchUserData2({
//     required String gender,
//     required int page,
//   }) async {
//     emit(state.copyWith(userDataState: DataState.initial));
//
//     final url =
//         'https://49dev.com/api/v1/tinder/?gender=$gender&page=$page&limit=20&subCategory=66af974f8bf69f9469944746';
//
//     final response = await _makeGetRequest(
//         url: url, accessToken: token, fromMethod: 'fetchUserData');
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       final userData = responseData
//           .map<UserData>((data) => UserData.fromJson(data))
//           .toList();
//
//       final updatedUserData = List<UserData>.from(state.userData)
//         ..addAll(userData);
//
//       emit(state.copyWith(
//         userData: updatedUserData,
//         userDataState: DataState.success,
//       ));
//     } else {
//       emit(state.copyWith(userDataState: DataState.failure));
//     }
//   }
//
//   Future<void> fetchUserData({
//     required String gender,
//   }) async {
//     emit(state.copyWith(userDataState: DataState.initial, userData: []));
//
//     final url =
//         // 'https://49dev.com/api/v1/b tinder/?gender=$gender&subCategory=66af974f8bf69f9469944746';
//         'https://49dev.com/api/v1/tinder/?gender=$gender&subCategory=66af974f8bf69f9469944746';
//     // 'https://49dev.com/api/v1/tinder/?gender=$gender&page=1&limit=10&subCategory=66af974f8bf69f9469944746';
//
//     final response = await _makeGetRequest(
//         url: url, accessToken: token, fromMethod: 'fetchUserData');
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       final userData = responseData
//           .map<UserData>((data) => UserData.fromJson(data))
//           .toList();
//       log(userData.first.lastName.toString()+"------------------------------------------------------------");
//       emit(
//           state.copyWith(userData: userData, userDataState: DataState.success));
//     } else {
//       emit(state.copyWith(userDataState: DataState.failure, userData: []));
//     }
//   }
//
//   Future<void> uploadPictures({
//     required List<String> pictures,
//   }) async {
//     emit(state.copyWith(uploadImageState: DataState.initial));
//
//     const url =
//         'https://49dev.com/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
//
//     final response = await _makePostRequest(
//       url: url,
//       accessToken: token,
//       body: jsonEncode({'pictures': pictures}),
//     );
//     emit(state.copyWith(uploadImageState: DataState.initial));
//
//     if (response != null) {
//       log('Upload successful: ${response.body}');
//       emit(state.copyWith(uploadImageState: DataState.success));
//     }
//   }
//
//   Future<http.Response?> _makeGetRequest({
//     required String url,
//     required String accessToken,
//     required String fromMethod,
//   }) async {
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
//         log('Failed to load data from -----$fromMethod -------------: ${response.statusCode} ${response.body}');
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
//   // Pan and Story handling methods
//   void updatePanStart(Offset startDragOffset) {
//     emit(state.copyWith(startDragOffset: startDragOffset));
//   }
//
//   void updatePanUpdate(Offset position, double rotation) {
//     emit(state.copyWith(position: position, rotation: rotation));
//   }
//
//   void resetPan() {
//     emit(state.copyWith(position: Offset.zero, rotation: 0));
//   }
//
//   void swipeAway() {
//     emit(state.copyWith(
//       position: Offset(state.position.dx * 50, state.position.dy * 50),
//     ));
//     Future.delayed(const Duration(milliseconds: 300), () {
//       emit(state.copyWith(
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
//         state.userData[state.currentIndex].pictures.length - 1) {
//       emit(state.copyWith(currentStoryIndex: state.currentStoryIndex + 1));
//     }
//   }
//
//   // void nextStory() {
//   //   final newIndex = (state.currentUserIndex + 1) % state.userData.length;
//   //   updateCurrentIndex(newIndex);
//   // }
//
//   void previousStory() {
//     if (state.currentStoryIndex > 0) {
//       emit(state.copyWith(currentStoryIndex: state.currentStoryIndex - 1));
//     }
//   }
//
//   void updateCurrentIndex(int newIndex) {
//     emit(state.copyWith(currentIndex: newIndex));
//   }
//
//   void resetStoryIndex() {
//     emit(state.copyWith(currentStoryIndex: 0));
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/near_by_model.dart';
import '../../data/models/tinder_person_model.dart';
import '../../data/repo/tinder_repo.dart';
import 'tinder_state.dart';

class TinderViewCubit extends Cubit<TinderViewState> {
  final TinderRepository tinderRepository;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _currentGender;

  TinderViewCubit({required this.tinderRepository})
      : super(TinderViewState.initial());

  Future<void> fetchUserData({
    required String gender,
    bool isLoadMore = false,
  }) async {
    // if (_isLoadingMore || _hasMoreData) {
    //   print('if (_isLoadingMore || !_hasMoreData) {');
    //   return;
    // }
    emit(state.copyWith(userDataState: DataState.initial));
    // Check if the gender has changed
    if (state.gender != gender) {
      _currentPage = 1;
      // _hasMoreData = true;
      emit(state.copyWith(userData: [], gender: gender)); // Clear existing data
    }

    final page = isLoadMore ? _currentPage + 1 : 1;
    _isLoadingMore = true;

    final userData = await tinderRepository.fetchUserData(gender, page);

    if (userData != null) {
      if (userData.isEmpty) {
        // _hasMoreData = false;
      } else {
        _currentPage = page;
        final List<UserData> updatedUserData = isLoadMore
            ? (List.from(state.userData)..addAll(userData))
            : userData;
        log("$gender/***************************************************************************************************************************************************************");

        emit(state.copyWith(
            userData: updatedUserData,
            userDataState: DataState.success,
            gender: state.gender));
      }
    } else {
      emit(state.copyWith(userDataState: DataState.failure));
    }

    _isLoadingMore = false;
  }

  Future<void> loadMoreUserData(String gender) async {
    log("*************************************************************************************************************************************************************** "
        "from loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData  loadMoreUserData ");
    await fetchUserData(gender: state.gender, isLoadMore: true);
  }

  Future<void> fetchMainCategoryById(String id) async {
    emit(state.copyWith(mainCategoryResponseState: DataState.initial));
    final mainCategoryResponse =
        await tinderRepository.fetchMainCategoryById(id);
    if (mainCategoryResponse != null) {
      print(mainCategoryResponse.data.mainCategory.nameEn);

      emit(state.copyWith(
          mainCategoryResponseState: DataState.success,
          mainCategoryResponse: mainCategoryResponse));
    } else {
      emit(state.copyWith(mainCategoryResponseState: DataState.failure));
    }
  }

  Future<bool> startNormalChat({
    required String receiverId,
    required String subCategoryId,
  }) async {
    emit(state.copyWith(normalChatResponseState: DataState.initial));
    final normalChatModel =
        await tinderRepository.startNormalChat(receiverId, subCategoryId);
    if (normalChatModel != null) {
      emit(state.copyWith(
          normalChatResponse: normalChatModel,
          normalChatResponseState: DataState.success));
      return true;
    } else {
      emit(state.copyWith(normalChatResponseState: DataState.failure));
      return false;
    }
  }

  Future<bool> startAnonymousChat({
    required String receiverId,
  }) async {
    emit(state.copyWith(anonymousChatResponseState: DataState.initial));
    final anonymousChatModel =
        await tinderRepository.startAnonymousChat(receiverId);
    if (anonymousChatModel != null) {
      emit(state.copyWith(
          anonymousChatResponse: anonymousChatModel,
          anonymousChatResponseState: DataState.success));
      return true;
    } else {
      emit(state.copyWith(anonymousChatResponseState: DataState.failure));
      return false;
    }
  }

  Future<void> fetchUserProfile({required String userId}) async {
    emit(state.copyWith(profileUserState: DataState.initial));
    final userModel = await tinderRepository.fetchUserProfile(userId);
    if (userModel != null) {
      emit(state.copyWith(
          profileUserState: DataState.success,
          profileUserData: userModel.data));
    } else {
      emit(state.copyWith(profileUserState: DataState.failure));
    }
  }

  Future<void> fetchFavorites() async {
    emit(state.copyWith(getFavCategoryListState: DataState.initial));
    final apiResponse = await tinderRepository.fetchFavorites();
    if (apiResponse != null) {
      emit(state.copyWith(
          getFavCategoryListState: DataState.success,
          getFavCategoryList: apiResponse));
    } else {
      emit(state.copyWith(getFavCategoryListState: DataState.failure));
    }
  }

  Future<void> fetchFavoritesCategory() async {
    emit(state.copyWith(getFavCategoryListState: DataState.initial));
    final apiResponse = await tinderRepository.fetchFavoritesCategory();
    if (apiResponse != null) {
      emit(state.copyWith(
          getFavCategoryListState: DataState.success,
          FavoriteCategoryList: apiResponse));
    } else {
      emit(state.copyWith(getFavCategoryListState: DataState.failure));
    }
  }

  Future<void> addFavoriteCategory({String? categoryId}) async {
    emit(state.copyWith(addCategoryModelState: DataState.initial));
    final isSuccess = await tinderRepository.addFavoriteCategory(categoryId!);
    if (isSuccess) {
      emit(state.copyWith(addCategoryModelState: DataState.success));
    } else {
      emit(state.copyWith(addCategoryModelState: DataState.failure));
    }
  }

  Future<bool> fetchLastSeen({
    required String userId,
  }) async {
    emit(state.copyWith(
      lastSeenModelState: DataState.initial,
    ));

    final lastSeenModel = await tinderRepository.fetchLastSeen(userId);
    if (lastSeenModel != null) {
      emit(state.copyWith(
          lastSeenModel: lastSeenModel, lastSeenModelState: DataState.success));
      return true;
      // print(lastSeenModel.data!.status.toString() +
      //     "sssssssssssssssssssssssssssssssss");
    } else {
      print("sssssssssssssssssssssssssssssssss");
      emit(state.copyWith(lastSeenModelState: DataState.failure));
      return false;
    }
  }

  Future<dynamic> sendGift({
    required String receiverId,
    required String giftId,
    required String subCategoryId,
  }) async {
    emit(state.copyWith(sendGiftErrorDataState: DataState.initial));
    final response =
        await tinderRepository.sendGift(receiverId, giftId, subCategoryId);
    if (response != null) {
      log("$response--------------------------------------");
      emit(state.copyWith(sendGiftErrorDataState: DataState.success));
      return response;
    } else {
      emit(state.copyWith(sendGiftErrorDataState: DataState.failure));
    }
    return '';
  }

  Future<void> fetchGifts() async {
    emit(state.copyWith(giftsState: DataState.initial));
    final giftData = await tinderRepository.fetchGifts();
    log("${giftData}dsssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    if (giftData != null) {
      emit(state.copyWith(gifts: giftData, giftsState: DataState.success));
    } else {
      emit(state.copyWith(giftsState: DataState.failure));
    }
  }

  Future<void> checkUserNearby({
    required String cardUserId,
  }) async {
    emit(state.copyWith(isUserNearbyState: DataState.initial));
    final nearByModel = await tinderRepository.checkUserNearby(cardUserId);
    if (nearByModel != null) {
      emit(state.copyWith(
          isUserNearby: nearByModel, isUserNearbyState: DataState.success));
    } else {
      emit(state.copyWith(
          isUserNearbyState: DataState.failure, isUserNearby: NearByModel()));
    }
  }

  Future<void> fetchSubCategoryData() async {
    emit(state.copyWith(subCategoryDataState: DataState.initial));
    final subCategoryData = await tinderRepository.fetchSubCategoryData();
    if (subCategoryData != null) {
      // fetchMainCategoryById('62c8b5b09332225799fe335e');
      emit(state.copyWith(
          subCategoryData: subCategoryData,
          subCategoryDataState: DataState.success));
    } else {
      emit(state.copyWith(subCategoryDataState: DataState.failure));
    }
  }

  // Future<void> fetchUserData({
  //   required String gender,
  // }) async {
  //   emit(state.copyWith(userDataState: DataState.initial, userData: []));
  //   final userData = await tinderRepository.fetchUserData(gender);
  //   if (userData != null) {
  //     log(userData.first.email.toString() +
  //         '000000000000000000000000000000000000000');
  //     emit(
  //         state.copyWith(userData: userData, userDataState: DataState.success));
  //   } else {
  //     emit(state.copyWith(userDataState: DataState.failure, userData: []));
  //   }
  // }

  Future<void> uploadPictures({
    required List<String> pictures,
  }) async {
    emit(state.copyWith(uploadImageState: DataState.initial));
    await tinderRepository.uploadPictures(pictures);
    emit(state.copyWith(uploadImageState: DataState.success));
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
