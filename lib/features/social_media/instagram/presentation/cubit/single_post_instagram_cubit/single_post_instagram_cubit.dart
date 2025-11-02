import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../domain/entities/single_post_instagram_entity.dart';
import '../../../domain/usecases/get_single_post_instagram_use_case.dart';

part 'single_post_instagram_state.dart';

class SinglePostInstagramCubit extends Cubit<SinglePostInstagramState> {
  final GetSinglePostInstagramUseCase _getSinglePostInstagramUseCase;

  SinglePostInstagramCubit(this._getSinglePostInstagramUseCase)
      : super(const SinglePostInstagramState());

  Future<void> getPost(String postId) async {
    emit(state.copyWith(status: SinglePostInstagramStatus.loading));
    final result = await _getSinglePostInstagramUseCase.call(postId);
    print('result get post ${result.toString()}');
    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: SinglePostInstagramStatus.failure,
          failure: failure,
        ));
      },
      (postData) {
        print('POST is $postData');

        emit(state.copyWith(
          status: SinglePostInstagramStatus.success,
          postData: postData,
        ));
        print('state POST is ${state.postData}');
      },
    );
  }
}
