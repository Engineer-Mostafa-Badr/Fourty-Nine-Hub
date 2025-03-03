import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';

class SendCallCubit extends Cubit<SendCallState> {
  SendCallCubit() : super(SendCallInitial());

  void setCallClosedState(String reason) =>
      emit(UnableSendCall(reason: reason));

  void setDeclinedCallState() =>
      emit(DeclinedCall());

  void setStatToCallRinging(CallData callData) =>
      emit(CallRinging(callData: callData));

  void setCallConnected() => emit(CallConnected());

  void setFakeCallConnected() => emit(FakeCallConnected());

  void setCallLoading() => emit(SendCallLoading());

}
