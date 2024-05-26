import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tinder_state.dart';

class TinderCubit extends Cubit<TinderState> {
  TinderCubit() : super(TinderInitial());
}
