// // import 'dart:convert';
// // import 'dart:developer';
// // import 'package:http/http.dart' as http;
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/anonymous_chat_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/main_category_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/normal_chat_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
// // import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
// // import 'package:fourtyninehub/service_locator/service_locator.dart';
// // import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// //
// // import '../../../../../core/utils/shared_pref.dart';
// // import '../models/tinder_person_model.dart';
// // import '../models/tinder_subcategory_model.dart';
// //
// // class TinderRepository {
// //   // final String token = serviceLocator<UserCubit>().token ?? '';
// //   String? token = await TokenManager.getAccessToken();
// //
// //   Future<http.Response?> _makeGetRequest({
// //     required String url,
// //     required String fromMethod,
// //   }) async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse(url),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //       );
// //
// //       if (response.statusCode == 200) {
// //         return response;
// //       } else {
// //         log('Failed to load data from -----$fromMethod -------------: ${response.statusCode} ${response.body}');
// //       }
// //     } catch (e) {
// //       log('Error fetching data: $e');
// //     }
// //     return null;
// //   }
// //
// //   Future<http.Response?> _makePostRequest({
// //     required String url,
// //     required String body,
// //   }) async {
// //     try {
// //       final response = await http.post(
// //         Uri.parse(url),
// //         headers: {
// //           'Authorization': 'Bearer $token',
// //           'Content-Type': 'application/json',
// //         },
// //         body: body,
// //       );
// //
// //       if (response.statusCode == 200) {
// //         return response;
// //       } else {
// //         log('Failed to post data: ${response.statusCode} ${response.body}');
// //       }
// //     } catch (e) {
// //       log('Error posting data: $e');
// //     }
// //     return null;
// //   }
// //
// //   Future<MainCategoryResponse?> fetchMainCategoryById(String id) async {
// //     final url = 'https://6db25d211280.ngrok-free.app/api/v1/categories/main/$id';
// //     final response =
// //         await _makeGetRequest(url: url, fromMethod: 'fetchMainCategoryById');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return MainCategoryResponse.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<NormalChatResponse?> startNormalChat(
// //       String receiverId, String subCategoryId) async {
// //     final url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/chat/start-chat/$receiverId?categoryId=$subCategoryId';
// //     final response = await _makePostRequest(url: url, body: '{}');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return NormalChatResponse.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<AnonymousChatResponse?> startAnonymousChat(String receiverId) async {
// //     final url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/chat/start-anonymous-chat/$receiverId';
// //     final response = await _makePostRequest(url: url, body: '{}');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return AnonymousChatResponse.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<ProfileUserModel?> fetchUserProfile(String userId) async {
// //     final uri = Uri.parse('https://6db25d211280.ngrok-free.app/api/v1/tinder/get-profile/$userId')
// //         .replace(queryParameters: {'subCategory': '66b2683f3a360fbdbf110767'});
// //     final response = await _makeGetRequest(
// //         url: uri.toString(), fromMethod: 'fetchUserProfile');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return ProfileUserModel.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<SubFavoritesResponse?> fetchFavorites() async {
// //     const url = 'https://6db25d211280.ngrok-free.app/api/v1/favorite-sub-category';
// //     final response =
// //         await _makeGetRequest(url: url, fromMethod: 'fetchFavorites');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return SubFavoritesResponse.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<bool> addFavoriteCategory(String categoryId) async {
// //     final url = 'https://6db25d211280.ngrok-free.app/api/v1/favorite-sub-category/$categoryId';
// //     final response = await _makePostRequest(url: url, body: '{}');
// //     return response != null && response.statusCode == 200;
// //   }
// //
// //   Future<LastSeenModel?> fetchLastSeen(String userId) async {
// //     final url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/users/last-seen/$userId?status=online';
// //     final response =
// //         await _makeGetRequest(url: url, fromMethod: 'fetchLastSeen');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return LastSeenModel.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<String?> sendGift(
// //       String receiverId, String giftId, String subCategoryId) async {
// //     const url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/tinder/sendGifts?subCategory=66af974f8bf69f9469944746';
// //     final data = jsonEncode({
// //       "receiverId": receiverId,
// //       "giftId": giftId,
// //     });
// //     final response = await _makePostRequest(url: url, body: data);
// //     return response?.body;
// //   }
// //
// //   Future<List<GiftData>?> fetchGifts() async {
// //     final url = 'https://6db25d211280.ngrok-free.app/api/v1/dashboard-gifts?limit=10';
// //     final response = await _makeGetRequest(url: url, fromMethod: 'fetchGifts');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       final giftApi = GiftApi.fromJson(data);
// //       return giftApi.data;
// //     }
// //     return null;
// //   }
// //
// //   Future<NearByModel?> checkUserNearby(String cardUserId) async {
// //     final url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/tinder/check-distance/$cardUserId?subCategory=66af974f8bf69f9469944746';
// //     final response =
// //         await _makeGetRequest(url: url, fromMethod: 'checkUserNearby');
// //     if (response != null) {
// //       final data = json.decode(response.body);
// //       return NearByModel.fromJson(data);
// //     }
// //     return null;
// //   }
// //
// //   Future<List<SubCategoryData>?> fetchSubCategoryData() async {
// //     const url = 'https://6db25d211280.ngrok-free.app/api/v1/tinder/subCategories';
// //     final response =
// //         await _makeGetRequest(url: url, fromMethod: 'fetchSubCategoryData');
// //     if (response != null) {
// //       final List<dynamic> responseData = jsonDecode(response.body)['data'];
// //       return responseData
// //           .map<SubCategoryData>((data) => SubCategoryData.fromJson(data))
// //           .toList();
// //     }
// //     return null;
// //   }
// //
// //   // Future<List<UserData>?> fetchUserData(String gender) async {
// //   //   // final url = 'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=$gender&subCategory=66af974f8bf69f9469944746';
// //   //   // final url =
// //   //   //     'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=female&page=4&subCategory=66af974f8bf69f9469944746&limit=10';
// //   //   final url =
// //   //       'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=$gender&&subCategory=66af974f8bf69f9469944746';
// //   //   final response =
// //   //       await _makeGetRequest(url: url, fromMethod: 'fetchUserData');
// //   //   if (response != null) {
// //   //     final List<dynamic> responseData = jsonDecode(response.body)['data'];
// //   //     return responseData
// //   //         .map<UserData>((data) => UserData.fromJson(data))
// //   //         .toList();
// //   //   }
// //   //   return null;
// //   // }
// //   // Future<List<UserData>?> fetchUserData(String gender, int page) async {
// //   //   final url =
// //   //       'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=$gender&page=$page&subCategory=66af974f8bf69f9469944746&limit=20';
// //   //
// //   //   final response =
// //   //   await _makeGetRequest(url: url, fromMethod: 'fetchUserData');
// //   //
// //   //   if (response != null) {
// //   //     final List<dynamic> responseData = jsonDecode(response.body)['data'];
// //   //     log("from fetchUserData repo  -----------------------------------------");
// //   //
// //   //     return responseData.map<UserData>((data) => UserData.fromJson(data)).toList();
// //   //   }
// //   //   return null;
// //   // }
// //   Future<List<UserData>?> fetchUserData(String gender, int page) async {
// //     final url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=$gender&page=$page&subCategory=66af974f8bf69f9469944746&limit=20';
// //
// //     final response = await _makeGetRequest(url: url, fromMethod: 'fetchUserData');
// //
// //     if (response != null) {
// //       final List<dynamic> responseData = jsonDecode(response.body)['data'];
// //       log("from fetchUserData repo  -----------------------------------------");
// //       return responseData.map<UserData>((data) => UserData.fromJson(data)).toList();
// //     }
// //     return null;
// //   }
// //
// //   Future<void> uploadPictures(List<String> pictures) async {
// //     const url =
// //         'https://6db25d211280.ngrok-free.app/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
// //     await _makePostRequest(url: url, body: jsonEncode({'pictures': pictures}));
// //   }
// // }
//
// import 'dart:convert';
// import 'dart:developer';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_category_model.dart';
// import 'package:fourtyninehub/features/subcategories/data/models/sub_category_model.dart';
// import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
// import 'package:http/http.dart' as http;
// import 'package:fourtyninehub/features/social_media/tinder/data/models/anonymous_chat_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/main_category_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/normal_chat_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/profile_user_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/last_seen_model.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/near_by_model.dart';
//
// import '../../../../../core/enums/wallet_types_enums.dart';
// import '../../../../../core/utils/shared_pref.dart';
// import '../../../../../service_locator/service_locator.dart';
// import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
// import '../models/tinder_person_model.dart';
//
// class TinderRepository {
//   String? token;
//
//   TinderRepository() {
//     _initializeToken();
//   }
//
//   Future<void> _initializeToken() async {
//     token = await CacheManager.getAccessToken();
//   }
//
//   Future<void> _ensureTokenInitialized() async {
//     token ??= await CacheManager.getAccessToken();
//   }
//
//   Future<http.Response?> _makeGetRequest({
//     required String url,
//     required String fromMethod,
//   }) async {
//     await _ensureTokenInitialized();
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );
//       var responseData = json.decode(response.body);
//       if (responseData['endPointSubscription'] != null &&
//           responseData['endPointSubscription'] == true &&
//           responseData['userSubscription'] == false) {
//         List<WalletTypes> wallets = (responseData['paymentMethod'] as List)
//             .map((e) => (e as String).toWalletType)
//             .toList();
//         await serviceLocator<SubscriptionController>().showSubscriptionPlans(
//             subCategoryId: responseData['subCategoryId'], wallets: wallets);
//       }
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
//     required String body,
//   }) async {
//     await _ensureTokenInitialized();
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//       // var responseData = json.decode(response.body);
//       // if (responseData['endPointSubscription'] != null &&
//       //     responseData['endPointSubscription'] == true &&
//       //     responseData['userSubscription'] == false) {
//       //   List<WalletTypes> wallets = (responseData['paymentMethod'] as List)
//       //       .map((e) => (e as String).toWalletType)
//       //       .toList();
//       //   await serviceLocator<SubscriptionController>().showSubscriptionPlans(
//       //       subCategoryId: responseData['subCategoryId'], wallets: wallets,title: 'hhh');
//       // }
//       if (response.statusCode == 200) {
//         return response;
//       } else {
//         log('Failed to post data: ${response.statusCode} ${response.body}');
//         return response;
//       }
//     } catch (e) {
//       log('Error posting data: $e');
//     }
//     return null;
//   }
//
//   Future<MainCategoryResponse?> fetchMainCategoryById(String id) async {
//     final url = 'https://6db25d211280.ngrok-free.app/api/v1/categories/main/$id';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchMainCategoryById');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return MainCategoryResponse.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<NormalChatResponse?> startNormalChat(
//       String receiverId, String subCategoryId) async {
//     final url =
//         'https://6db25d211280.ngrok-free.app/api/v1/chat/start-chat/$receiverId?categoryId=$subCategoryId';
//     final response = await _makePostRequest(url: url, body: '{}');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return NormalChatResponse.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<AnonymousChatResponse?> startAnonymousChat(String receiverId) async {
//     final url =
//         'https://6db25d211280.ngrok-free.app/api/v1/chat/start-anonymous-chat/$receiverId';
//     final response = await _makePostRequest(url: url, body: '{}');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return AnonymousChatResponse.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<ProfileUserModel?> fetchUserProfile(String userId) async {
//     final uri = Uri.parse('https://6db25d211280.ngrok-free.app/api/v1/tinder/get-profile/$userId')
//         .replace(queryParameters: {'subCategory': '66b2683f3a360fbdbf110767'});
//     final response = await _makeGetRequest(
//         url: uri.toString(), fromMethod: 'fetchUserProfile');
//     if (response != null) {
//       final data = json.decode(response.body);
//       print("${response.body}fetchUserProfile");
//       return ProfileUserModel.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<SubFavoritesResponse?> fetchFavorites() async {
//     const url = 'https://6db25d211280.ngrok-free.app/api/v1/favorite-sub-category';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchFavorites');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return SubFavoritesResponse.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<CategoryFavoritesResponse?> fetchFavoritesCategory() async {
//     const url = 'https://6db25d211280.ngrok-free.app/api/v1/favorite-category';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchFavorites');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return CategoryFavoritesResponse.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<bool> addFavoriteCategory(String categoryId) async {
//     final url = 'https://6db25d211280.ngrok-free.app/api/v1/favorite-sub-category/$categoryId';
//     final response = await _makePostRequest(url: url, body: '{}');
//     return response != null && response.statusCode == 200;
//   }
//
//   Future<LastSeenModel?> fetchLastSeen(String userId) async {
//     final url = 'https://6db25d211280.ngrok-free.app/api/v1/users/last-seen/$userId';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchLastSeen');
//     if (response != null) {
//       final data = json.decode(response.body);
//       print("${response.body}vvvvvvvvvvvvvvvvv");
//       return LastSeenModel.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<dynamic> sendGift(
//       String receiverId, String giftId, String subCategoryId) async {
//     const url =
//         'https://6db25d211280.ngrok-free.app/api/v1/tinder/sendGifts?subCategory=66af974f8bf69f9469944746';
//     final data = jsonEncode({
//       "receiverId": receiverId,
//       "giftId": giftId,
//     });
//     final response = await _makePostRequest(url: url, body: data);
//     final s = await json.decode(response!.body);
//     var responseData = json.decode(response.body);
//     if (responseData['endPointSubscription'] != null &&
//         responseData['endPointSubscription'] == true &&
//         responseData['userSubscription'] == false) {
//       List<WalletTypes> wallets = (responseData['paymentMethod'] as List)
//           .map((e) => (e as String).toWalletType)
//           .toList();
//       await serviceLocator<SubscriptionController>().showSubscriptionPlans(
//           subCategoryId: responseData['subCategoryId'],
//           wallets: wallets,
//           title: 'Gift Subscription');
//     }
//     log('-------->${s["success"]}');
//     return s;
//   }
//
//   Future<List<GiftData>?> fetchGifts() async {
//     const url = 'https://6db25d211280.ngrok-free.app/api/v1/dashboard-gifts?limit=10';
//     final response = await _makeGetRequest(url: url, fromMethod: 'fetchGifts');
//     if (response != null) {
//       final data = json.decode(response.body);
//       final giftApi = GiftApi.fromJson(data);
//       return giftApi.data!.gifts;
//     }
//     return null;
//   }
//
//   Future<NearByModel?> checkUserNearby(String cardUserId) async {
//     final url =
//         'https://6db25d211280.ngrok-free.app/api/v1/tinder/check-distance/$cardUserId?subCategory=66af974f8bf69f9469944746';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'checkUserNearby');
//     if (response != null) {
//       final data = json.decode(response.body);
//       return NearByModel.fromJson(data);
//     }
//     return null;
//   }
//
//   Future<List<SubCategoryEntity>?> fetchSubCategoryData() async {
//     const url = 'https://6db25d211280.ngrok-free.app/api/v1/tinder/subCategories';
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchSubCategoryData');
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       return responseData
//           .map<SubCategoryEntity>((data) => SubCategoryModel.fromJson(data))
//           .toList();
//     }
//     return null;
//   }
//
//   Future<List<UserData>?> fetchUserData(String gender, int page) async {
//     final url =
//         'https://6db25d211280.ngrok-free.app/api/v1/tinder/?gender=$gender&page=$page&subCategory=66af974f8bf69f9469944746&limit=20';
//
//     final response =
//         await _makeGetRequest(url: url, fromMethod: 'fetchUserData');
//
//     if (response != null) {
//       final List<dynamic> responseData = jsonDecode(response.body)['data'];
//       log("from fetchUserData repo  -----------------------------------------");
//       return responseData
//           .map<UserData>((data) => UserData.fromJson(data))
//           .toList();
//     }
//     return null;
//   }
//
//   Future<void> uploadPictures(List<String> pictures) async {
//     const url =
//         'https://6db25d211280.ngrok-free.app/api/v1/tinder/uploadPictures?subCategory=66af974f8bf69f9469944746';
//     await _makePostRequest(url: url, body: jsonEncode({'pictures': pictures}));
//   }
// }
