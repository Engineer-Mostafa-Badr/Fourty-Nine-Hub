import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'azkaar_state.dart';

class AzkaarCubit extends Cubit<AzkaarState> {
  AzkaarCubit() : super(AzkaarInitial());
}
