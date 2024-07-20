import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'instagram_state.dart';

class InstagramCubit extends Cubit<InstagramState> {
  InstagramCubit() : super(InstagramInitial());
}
