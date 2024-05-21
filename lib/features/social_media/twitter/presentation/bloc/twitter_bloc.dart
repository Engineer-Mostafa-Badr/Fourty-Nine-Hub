import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'twitter_event.dart';
part 'twitter_state.dart';

class TwitterBloc extends Bloc<TwitterEvent, TwitterState> {
  TwitterBloc() : super(TwitterInitial()) {
    on<TwitterEvent>((event, emit) {

    });
  }
}
