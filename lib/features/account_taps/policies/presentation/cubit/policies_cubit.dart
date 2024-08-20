import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'policies_state.dart';

class PoliciesCubit extends Cubit<PoliciesState> {
  PoliciesCubit() : super(PoliciesInitial());
}
