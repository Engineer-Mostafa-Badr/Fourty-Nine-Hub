
// preload_event.dart
abstract class PreloadEvent {}

class GetVideosFromApiEvent extends PreloadEvent {}

class SetLoading extends PreloadEvent {}

class UpdateUrls extends PreloadEvent {
  final List<String> urls;
  UpdateUrls(this.urls);
}

class OnVideoIndexChanged extends PreloadEvent {
  final int index;
  OnVideoIndexChanged(this.index);
}
