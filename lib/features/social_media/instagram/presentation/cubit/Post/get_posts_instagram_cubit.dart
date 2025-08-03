import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../common/models/public/pagination_params.dart';
import '../../../domain/usecases/get_posts_use_case.dart';
import 'post_instagram_state.dart';

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
