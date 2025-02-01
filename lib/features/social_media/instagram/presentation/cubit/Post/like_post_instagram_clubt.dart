import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/Post/post_instagram_state.dart';

class LikePostInstagramClubt extends Cubit<PostInstagramState> {
  LikePostInstagramClubt() : super(InitialPostInstagramState());
}