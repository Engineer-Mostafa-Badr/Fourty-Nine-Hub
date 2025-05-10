import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reels_specific_user_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_specific_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_suggest_follow_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/post_follow_user_instagram_use_case.dart';

import '../../../domain/usecases/unfollow_user_instagram_use_case.dart';
part 'profile_instagram_state.dart';

class ProfileInstagramCubit extends Cubit<ProfileInstagramState> {
  ProfileInstagramCubit(
    this._getProfileUC,
    this._getReelsUC,
    this._getSuggestFollowUC,
    this._postFollowUserUC,
      this._unFollowUserInstagramUC,
  ) : super(const ProfileInstagramState());

  final GetInstagramProfileUseCase _getProfileUC;
  final GetInstagramReelsSpecificUserUseCase _getReelsUC;
  final GetSuggestFollowInstagramUseCase _getSuggestFollowUC;
  final PostFollowUserInstagramUseCase _postFollowUserUC;
  final UnFollowUserInstagramUseCase _unFollowUserInstagramUC;

  final int postsLimit = 10;
  final int reelsLimit = 10;
  final int suggestFollowLimit = 10;

  // يمكن استدعاء هذه الدالة لتحميل كل البيانات مرة واحدة
  Future<void> getUserProfile({required String userId}) async {
   await fetchProfile(userId);
   await fetchReels(userId);
   await fetchSuggestFollow();
  }

  // تحميل ملف الشخصية فقط
  Future<void> fetchProfile(String userId) async {
    emit(state.copyWith(profileStatus: LoadingStatus.loading));

    final res = await _getProfileUC(GetInstagramProfileParams(
        userId: userId, page: state.postsPage, limit: postsLimit));

    res.fold(
      (f) {
        emit(state.copyWith(
            profileStatus: LoadingStatus.failure, profileFailure: f));
      },
      (data) {
        emit(state.copyWith(
            profileStatus: LoadingStatus.success,
            profileData: data,
            // allPosts: data.postsEntity,
            postsPage: state.postsPage + 1));
      },
    );
  }

  // تحميل المزيد من منشورات الملف الشخصي
  // Future<void> fetchMorePosts(String userId) async {
  //   // نتحقق أولاً إذا كان هناك تحميل جارٍ
  //   if (state.profileStatus == LoadingStatus.loading) return;

  //   emit(state.copyWith(profileStatus: LoadingStatus.loading));

  //   final res = await _getProfileUC(GetInstagramProfileParams(
  //       userId: userId, page: state.postsPage, limit: postsLimit));

  //   res.fold(
  //     (f) {
  //       emit(state.copyWith(
  //           profileStatus: LoadingStatus.failure, profileFailure: f));
  //     },
  //     (data) {
  //       // استخراج المنشورات الجديدة من data
  //       final newPosts = data.postsEntity;

  //       // دمج المنشورات القديمة مع الجديدة
  //       final updatedPosts = [...state.profileData!.postsEntity, ...newPosts];

  //       emit(state.copyWith(
  //           profileStatus: LoadingStatus.success,
  //           profileData: data, // البيانات الأساسية (بدون دمج)
  //           allPosts: updatedPosts, // القائمة المدمجة
  //           postsPage: state.postsPage + 1));
  //     },
  //   );
  // }

  // تحميل الريلز فقط
  Future<void> fetchReels(String userId) async {
    emit(state.copyWith(reelsStatus: LoadingStatus.loading));

    final res = await _getReelsUC(GetInstagramReelsSpecificUserParams(
        userId: userId, page: state.reelsPage, limit: reelsLimit));

    res.fold(
      (f) {
        emit(state.copyWith(
            reelsStatus: LoadingStatus.failure, reelsFailure: f));
      },
      (data) {
        emit(state.copyWith(
            reelsStatus: LoadingStatus.success,
            reelsData: data,
            reelsPage: state.reelsPage + 1));
      },
    );
  }

  // تحميل المزيد من الريلز
  // Future<void> fetchMoreReels(String userId) async {
  //   // نتحقق أولاً إذا كان هناك تحميل جارٍ
  //   if (state.reelsStatus == LoadingStatus.loading) return;

  //   emit(state.copyWith(reelsStatus: LoadingStatus.loading));

  //   final res = await _getReelsUC(GetInstagramReelsSpecificUserParams(
  //       userId: userId, page: state.reelsPage, limit: reelsLimit));

  //   res.fold(
  //     (f) {
  //       emit(state.copyWith(
  //           reelsStatus: LoadingStatus.failure, reelsFailure: f));
  //     },
  //     (data) {
  //       // دمج البيانات الجديدة مع البيانات القديمة
  //       final updatedData = state.reelsData?.copyWith(
  //           reels: [...(state.reelsData?.reels ?? []), ...(data.reels ?? [])]);

  //       emit(state.copyWith(
  //           reelsStatus: LoadingStatus.success,
  //           reelsData: updatedData,
  //           reelsPage: state.reelsPage + 1));
  //     },
  //   );
  // }

  // تحميل اقتراحات المتابعة فقط
  Future<void> fetchSuggestFollow() async {
    emit(state.copyWith(suggestFollowStatus: LoadingStatus.loading));

    final res = await _getSuggestFollowUC(
      GetSuggestFollowInstagramParams(
        limit: suggestFollowLimit,
        page: state.suggestFollowPage,
      ),
    );

    res.fold(
      (f) {
        emit(state.copyWith(
            suggestFollowStatus: LoadingStatus.failure,
            suggestFollowFailure: f));
      },
      (data) {
        emit(state.copyWith(
            suggestFollowStatus: LoadingStatus.success,
            suggestFollowsData: data,
            suggestFollowPage: state.suggestFollowPage + 1));
      },
    );
  }

  // تحميل المزيد من اقتراحات المتابعة
  // Future<void> fetchMoreSuggestFollow() async {
  //   // نتحقق أولاً إذا كان هناك تحميل جارٍ
  //   if (state.suggestFollowStatus == LoadingStatus.loading) return;

  //   emit(state.copyWith(suggestFollowStatus: LoadingStatus.loading));

  //   final res = await _getSuggestFollowUC(
  //     GetSuggestFollowInstagramParams(
  //       limit: suggestFollowLimit,
  //       page: state.suggestFollowPage,
  //     ),
  //   );

  //   res.fold(
  //     (f) {
  //       emit(state.copyWith(
  //           suggestFollowStatus: LoadingStatus.failure,
  //           suggestFollowFailure: f));
  //     },
  //     (data) {
  //       // دمج البيانات الجديدة مع البيانات القديمة
  //       final updatedData = state.suggestFollowsData?.copyWith(suggestions: [
  //         ...(state.suggestFollowsData?.suggestions ?? []),
  //         ...(data.suggestions ?? [])
  //       ]);

  //       emit(state.copyWith(
  //           suggestFollowStatus: LoadingStatus.success,
  //           suggestFollowsData: updatedData,
  //           suggestFollowPage: state.suggestFollowPage + 1));
  //     },
  //   );
  // }

  // متابعة مستخدم
  Future<void> followUser(String userId) async {
    emit(state.copyWith(addFollowStatus: LoadingStatus.loading));
    final res =
        await _postFollowUserUC(PostFollowUserInstagramParams(userId: userId));

    res.fold(
      (f) {
        emit(state.copyWith(
            addFollowStatus: LoadingStatus.failure, addFollowFailure: f));
        },
      (success) {
        emit(state.copyWith(addFollowStatus: LoadingStatus.success));
        removeFollowUser(userId);
      },
    );
  }
  Future<void> unFollowUser(String userId) async {
    emit(state.copyWith(addFollowStatus: LoadingStatus.loading));
    final res =
        await _unFollowUserInstagramUC(PostFollowUserInstagramParams(userId: userId));

    res.fold(
      (f) {
        emit(state.copyWith(
            addFollowStatus: LoadingStatus.failure, addFollowFailure: f));
        },
      (success) {
        emit(state.copyWith(addFollowStatus: LoadingStatus.success));
      },
    );
  }

  // إزالة مستخدم من قائمة الاقتراحات بعد متابعته
  void removeFollowUser(String userId) {
    final suggestFollowsData = state.suggestFollowsData;
    if (suggestFollowsData != null) {
      final suggestions =
          List<SuggestionEntity>.from(suggestFollowsData.suggestions ?? []);

      suggestions.removeWhere((element) => element.userId == userId);

      final updatedData = DataSuggestFollowInstagramEntity(
        suggestions: suggestions,
        paginationDetails: state.suggestFollowsData!.paginationDetails,
      );
      //suggestFollowsData.copyWith(suggestions: suggestions);

      emit(state.copyWith(suggestFollowsData: updatedData));
    }
  }

  // إعادة تعيين حالة محددة
  void resetStatus(
      {bool profile = false, bool reels = false, bool suggestFollow = false}) {
    emit(state.copyWith(
      profileStatus: profile ? LoadingStatus.initial : null,
      reelsStatus: reels ? LoadingStatus.initial : null,
      suggestFollowStatus: suggestFollow ? LoadingStatus.initial : null,
    ));
  }

  // إعادة تعيين كل الحالات
  void resetAllStatus() {
    resetStatus(profile: true, reels: true, suggestFollow: true);
  }
}
