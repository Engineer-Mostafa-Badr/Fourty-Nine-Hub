import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/use_case/get_gifts_use_case.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/gift_state.dart';

import '../../../../../core/utils/shared_pref.dart';

class GiftsCubit extends Cubit<GiftsState> {
  String? token;
  int _currentPage = 1;
  final int _limit = 20;
  bool _isFetching = false;

  final GetGiftsUseCase _getGiftsUseCase;

  GiftsCubit(this._getGiftsUseCase) : super(GiftsInitial()) {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    token = await CacheManager.getAccessToken();
  }

  Future<void> _ensureTokenInitialized() async {
    token ??= await CacheManager.getAccessToken();
  }

  void fetchGifts() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      await _ensureTokenInitialized();
      final newGifts = await _fetchGiftsFromApi(token!);
      emit(GiftsLoaded(
          [...state.gifts, ...newGifts!.gifts!], newGifts.length ?? 0));
      _currentPage++;
    } catch (e) {
      emit(GiftsError(e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<GiftsData?> _fetchGiftsFromApi(String accessToken) async {
    final response = await _getGiftsUseCase(
      PaginationParams(page: _currentPage, limit: _limit),
    );
    GiftsData? responseData;
    response.fold((failure) {
      throw Exception("Failed to fetch gifts");
    }, (data) async {
      responseData = data.data;
    });
    return responseData;
  }
}
