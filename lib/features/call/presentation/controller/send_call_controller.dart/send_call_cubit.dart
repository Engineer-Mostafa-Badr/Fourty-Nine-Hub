import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';
import 'package:fourtyninehub/features/call/services/call_timer_service.dart';

class SendCallCubit extends Cubit<SendCallState> {
  SendCallCubit() : super(SendCallInitial());

  void setCallClosedState(String reason) =>
      emit(UnableSendCall(reason: reason));

  void setDeclinedCallState() => emit(DeclinedCall());

  void setStatToCallRinging(CallData callData) =>
      emit(CallRinging(callData: callData));

  void setCallConnected() {
    emit(CallConnected());
     CallTimerService().startTimer();
  }

  void setFakeCallConnected() => emit(FakeCallConnected());

  void setCallLoading() => emit(SendCallLoading());

  bool _isMinimized = false;
  bool get isCallMinimized => _isMinimized;
  // UserModel? _currentReceiver;
  // UserModel? get currentReceiver => _currentReceiver;

  void minimizeCall() {
    _isMinimized = true;
    
    // Re-emit the current state to trigger UI updates
    final currentState = state;
    if (currentState is CallConnected) {
      emit(CallMinimized(isMinimized: _isMinimized));
      // emit(currentState);
      print("Call minimized, timer preserved");
    }
  }

  void maximizeCall() {
    _isMinimized = false;
    
    // Re-emit the current state to trigger UI updates
    // final currentState = state;
    // if (currentState is CallConnected) {
      emit(CallMinimized(isMinimized: _isMinimized));
      emit(CallConnected());
    //   print("Call maximized, timer preserved");
    // }
  }
}
