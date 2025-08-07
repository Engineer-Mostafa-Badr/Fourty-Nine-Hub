import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/models/public/pagination_params.dart';
import '../../../domain/usecases/get_posts_use_case.dart';
import 'post_instagram_state.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

class GetPostsInstagramCubit extends Cubit<PostInstagramState> {
  final GetPostsUseCase getPostsUseCase;
  GetPostsInstagramCubit({required this.getPostsUseCase})
      : super(InitialPostInstagramState());

  getPosts() async {
    emit(LoadingPostInstagramState());
    var response = await getPostsUseCase.call(PaginationParams(
      page: 1,
      limit: 10,
    ));
    response.fold(
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        emit(FailurePostInstagramState(
          failure: l,
        ));
      },
      (r) {
        emit(SuccessCreatePostInstagramState(
            // posts: r,
            ));
      },
    );
  }
}
