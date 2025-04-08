import 'package:bloc/bloc.dart';

part 'profile_instagram_state.dart';

class ProfileInstagramCubit extends Cubit<ProfileInstagramState> {
  ProfileInstagramCubit() : super(const ProfileInstagramState());

  Future<void> getUserProfile({required String id}) async {}
}
