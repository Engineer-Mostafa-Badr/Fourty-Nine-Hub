import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'healthcare_event.dart';
part 'healthcare_state.dart';

class HealthcareBloc extends Bloc<HealthcareEvent, HealthcareState> {
  HealthcareBloc() : super(HealthcareInitial()) {
    on<HealthcareEvent>((event, emit) {
      
    });
  }
}
