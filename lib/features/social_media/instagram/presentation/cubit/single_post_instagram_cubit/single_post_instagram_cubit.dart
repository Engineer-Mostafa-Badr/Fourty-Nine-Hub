import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'single_post_instagram_state.dart';

class SinglePostInstagramCubit extends Cubit<SinglePostInstagramState> {
  SinglePostInstagramCubit() : super(SinglePostInstagramInitial());

  Future<void> getPost(String postId) async {}
}
