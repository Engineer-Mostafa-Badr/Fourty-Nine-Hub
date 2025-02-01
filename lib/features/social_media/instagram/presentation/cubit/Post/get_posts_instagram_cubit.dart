import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/repositories/instagram_repository.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/post_instagram_state.dart';

class GetPostsInstagramCubit extends Cubit<PostInstagramState> {
  final InstagramRepository repository;
  GetPostsInstagramCubit({required this.repository})
      : super(InitialPostInstagramState());

  getPosts() async {
    emit(LoadingPostInstagramState());
    var response = await repository.getPosts(page: 1, limit: 100);
    response.fold(
      (l) {},
      (r) {},
    );
  }
}
