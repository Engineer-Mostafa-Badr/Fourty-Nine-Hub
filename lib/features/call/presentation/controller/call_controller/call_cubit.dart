
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(NoCalls());

  
}
