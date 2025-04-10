import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/call/widgets/minimized_call_overlay.dart';

part 'minimize_state.dart';

class MinimizeCubit extends Cubit<MinimizeState> {
  MinimizeCubit() : super(MinimizeInitial());

  bool _isMinimized = false;
  bool get isCallMinimized => _isMinimized;

  // Simple minimize function - just changes state
  void minimizeCall() {
    if (_isMinimized) return; // Prevent duplicate minimization
    
    _isMinimized = true;
    emit(CallMinimized(isMinimized: true));
    print("Call minimized, timer preserved");
    
    // Don't manage overlay here - let UI components handle that
  }

  // Simple maximize function - just changes state
  void maximizeCall() {
    if (!_isMinimized) return; // Prevent duplicate maximization
    
    _isMinimized = false;
    emit(CallMinimized(isMinimized: false));
    print("Call maximized, timer preserved");
    
    // Don't manage overlay here - let UI components handle that
  }
  
  // Simple end call function - just resets state
  void endCall() {
    _isMinimized = false;
    emit(CallMinimized(isMinimized: false));
    print("Call ended and cleaned up");
  }
}
