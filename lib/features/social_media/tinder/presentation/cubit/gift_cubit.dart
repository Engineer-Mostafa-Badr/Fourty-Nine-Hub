// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
// import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:http/http.dart' as http;
//
// class GiftsCubit extends Cubit<GiftsState> {
//   GiftsCubit() : super(GiftsInitial());
//   final String token = serviceLocator<UserCubit>().token ?? '';
//
//   int _currentPage = 1;
//   final int _limit = 20;
//   bool _isFetching = false;
//
//   void fetchGifts() async {
//     if (_isFetching) return;
//
//     _isFetching = true;
//     try {
//       final newGifts = await _fetchGiftsFromApi(token);
//       emit(GiftsLoaded([...state.gifts, ...newGifts]));
//       _currentPage++;
//     } catch (e) {
//       emit(GiftsError(e.toString()));
//     } finally {
//       _isFetching = false;
//     }
//   }
//
//   Future<List<GiftData>> _fetchGiftsFromApi(String accessToken) async {
//     final response = await _makeGetRequest(
//       url:
//           'https://49dev.com/api/v1/dashboard-gifts?limit=$_limit&page=$_currentPage',
//       accessToken: accessToken,
//       fromMethod: 'fetchGifts',
//     );
//
//     final giftApi = GiftApi.fromJson(jsonDecode(response!.body));
//     return giftApi.data ?? [];
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
//       log(response.body+"11111111111111111111111111111111111111");
//
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
// }
//
// class GiftsState {
//   final List<GiftData> gifts;
//
//   GiftsState(this.gifts);
// }
//
// class GiftsInitial extends GiftsState {
//   GiftsInitial() : super([]);
// }
//
// class GiftsLoaded extends GiftsState {
//   GiftsLoaded(super.gifts);
// }
//
// class GiftsError extends GiftsState {
//   final String message;
//
//   GiftsError(this.message) : super([]);
// }

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/shared_pref.dart';

class GiftsCubit extends Cubit<GiftsState> {
  String? token;
  int _currentPage = 1;
  final int _limit = 20;
  bool _isFetching = false;

  GiftsCubit() : super(GiftsInitial()) {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    token = await TokenManager.getAccessToken();
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await TokenManager.getAccessToken();
  }

  void fetchGifts() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      await _ensureTokenInitialized();
      final newGifts = await _fetchGiftsFromApi(token!);
      emit(GiftsLoaded([...state.gifts, ...newGifts]));
      _currentPage++;
    } catch (e) {
      emit(GiftsError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<List<GiftData>> _fetchGiftsFromApi(String accessToken) async {
    final response = await _makeGetRequest(
      url:
          'https://49dev.com/api/v1/dashboard-gifts?limit=$_limit&page=$_currentPage',
      accessToken: accessToken,
      fromMethod: 'fetchGifts',
    );

    if (response != null) {
      final giftApi = GiftApi.fromJson(jsonDecode(response.body));
      return giftApi.data ?? [];
    } else {
      throw Exception("Failed to fetch gifts");
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
}

class GiftsState {
  final List<GiftData> gifts;

  GiftsState(this.gifts);
}

class GiftsInitial extends GiftsState {
  GiftsInitial() : super([]);
}

class GiftsLoaded extends GiftsState {
  GiftsLoaded(super.gifts);
}

class GiftsError extends GiftsState {
  final String message;

  GiftsError(this.message) : super([]);
}
