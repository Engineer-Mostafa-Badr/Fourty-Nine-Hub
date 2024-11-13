
import 'package:fourtyninehub/features/social_media/tinder/data/models/gift_model.dart';

class GiftsState {
  final List<GiftData> gifts;
  final int length;

  GiftsState(this.gifts, this.length);
}

class GiftsInitial extends GiftsState {
  GiftsInitial() : super([], 0);
}

class GiftsLoaded extends GiftsState {
  GiftsLoaded(super.gifts, super.length);
}

class GiftsError extends GiftsState {
  final String message;

  GiftsError(this.message) : super([], 0);
}
