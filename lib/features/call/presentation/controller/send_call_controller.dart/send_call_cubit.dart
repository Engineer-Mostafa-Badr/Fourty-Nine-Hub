import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';

class SendCallCubit extends Cubit<SendCallState> {
  SendCallCubit() : super(SendCallInitial());


}
