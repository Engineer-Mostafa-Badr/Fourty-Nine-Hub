import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_tag_use_case.dart';

part 'tag_users_state.dart';

class TagUsersCubit extends Cubit<TagUsersState> {
  TagUsersCubit(this._getUserTagUseCase) : super(const TagUsersState());

  final GetUserTagUseCase _getUserTagUseCase;

  Future<void> searchUsersTag(String username) async {
    emit(state.copyWith(status: TagUsersStates.loading));
    final result = await _getUserTagUseCase.call(username);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TagUsersStates.error,
          failure: failure,
        ),
      ),
      (userTag) => emit(
        state.copyWith(
          status: TagUsersStates.success,
          users: userTag,
        ),
      ),
    );
  }
}
