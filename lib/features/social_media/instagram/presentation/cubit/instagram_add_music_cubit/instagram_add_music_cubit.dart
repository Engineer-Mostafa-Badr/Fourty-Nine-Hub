import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'instagram_add_music_state.dart';

class InstagramAddMusicCubit extends Cubit<InstagramAddMusicState> {
  InstagramAddMusicCubit() : super(const InstagramAddMusicState());

  void playAudio() {

  }

  final List<String> musicSections = [
    'For You',
    'Trending',
    'Saved',
    'Original Audio',
  ];

  void changeMusicSection(int index) {
    if(state.activeMusicSectionIndex == index) return;
    emit(state.copyWith(
      activeMusicSectionIndex: index,
    ));
  }

}
