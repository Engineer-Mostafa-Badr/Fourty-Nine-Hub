import 'package:bloc/bloc.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/user_tag_entity.dart';
import '../../../domain/usecases/get_user_tag_use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'tag_users_state.dart';

class TagUsersCubit extends Cubit<TagUsersState> {
  TagUsersCubit(this._getUserTagUseCase) : super(const TagUsersState());

  final GetUserTagUseCase _getUserTagUseCase;

  List<UserTagEntity> users = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 20;

  Future<void> loadInitialData(String username) async {
    emit(state.copyWith(
      status: TagUsersStates.loading,
    ));
    users.clear();
    currentPage = 1;
    hasMoreData = true;

    await searchUsersTag(username);
  }

  Future<void> searchUsersTag(String username) async {
    if (!state.hasMoreData || state.isLoadingMore) return;

    isLoadingMore = true;

    final result = await _getUserTagUseCase.call(
      GetUserTagParams(
        username: username,
        page: currentPage,
        limit: pageSize,
      ),
    );

    result.fold(
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure, status: TagUsersStates.error));
      },
      (data) {
        users.addAll(data);

        if (data.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        emit(state.copyWith(status: TagUsersStates.success));
      },
    );
    isLoadingMore = false;

    // result.fold(
    //   (failure) => emit(
    //     state.copyWith(
    //       status: TagUsersStates.error,
    //       failure: failure,
    //     ),
    //   ),
    //   (userTag) => emit(
    //     state.copyWith(
    //       status: TagUsersStates.success,
    //       users: userTag,
    //     ),
    //   ),
    // );
  }
}
