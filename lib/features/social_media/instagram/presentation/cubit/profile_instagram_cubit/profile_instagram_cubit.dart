import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reels_specific_user_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_specific_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_suggest_follow_instagram_use_case.dart';

part 'profile_instagram_state.dart';

class ProfileInstagramCubit extends Cubit<ProfileInstagramState> {
  ProfileInstagramCubit(
    this._getProfileUC,
    this._getReelsUC,
    this._getSuggestFollowUC,
  ) : super(const ProfileInstagramState());

  final GetInstagramProfileUseCase _getProfileUC;
  final GetInstagramReelsSpecificUserUseCase _getReelsUC;
  final GetSuggestFollowInstagramUseCase _getSuggestFollowUC;

  final int postsLimit = 10;
  final int reelsLimit = 10;
  final int suggestFollowLimit = 10;

  Future<void> getUserProfile({required String userId}) async {
    emit(state.copyWith(status: ProfileInstagramStatus.loading));

    final profileResult = await _fetchProfile(userId);
    if (profileResult.isLeft()) return; // الحالة أُرسلت جوه الدالة

    final reelsResult = await _fetchReels(userId);
    if (reelsResult.isLeft()) return;

    final suggestFollowResult = await _fetchSuggestFollow();
    if (suggestFollowResult.isLeft()) return;

    // لو كله نجح
    emit(state.copyWith(status: ProfileInstagramStatus.success));
  }

  Future<Either<Failure, ProfileInstagramDataEntity>> _fetchProfile(
      String userId) async {
    final res = await _getProfileUC(GetInstagramProfileParams(
        userId: userId, page: state.postsPage, limit: postsLimit));
    return res.fold(
      (f) {
        emit(
            state.copyWith(status: ProfileInstagramStatus.failure, failure: f));
        return left(f);
      },
      (data) {
        emit(state.copyWith(profileData: data));
        return right(data);
      },
    );
  }

  Future<Either<Failure, ReelsSpecificUserDataEntity>> _fetchReels(
      String userId) async {
    final res = await _getReelsUC(GetInstagramReelsSpecificUserParams(
        userId: userId, page: state.reelsPage, limit: reelsLimit));
    return res.fold(
      (f) {
        emit(
            state.copyWith(status: ProfileInstagramStatus.failure, failure: f));
        return left(f);
      },
      (data) {
        emit(state.copyWith(reelsData: data));
        return right(data);
      },
    );
  }

  Future<Either<Failure, DataSuggestFollowInstagramEntity>>
      _fetchSuggestFollow() async {
    final res = await _getSuggestFollowUC(
      GetSuggestFollowInstagramParams(
        limit: suggestFollowLimit,
        page: state.suggestFollowPage,
      ),
    );
    return res.fold(
      (f) {
        emit(
            state.copyWith(status: ProfileInstagramStatus.failure, failure: f));
        return left(f);
      },
      (data) {
        emit(state.copyWith(suggestFollowsData: data));
        return right(data);
      },
    );
  }

  Future<void> followUser(String userId) async {}

  void removeFollowUser(String userId) {}
}
