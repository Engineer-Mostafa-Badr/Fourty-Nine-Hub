import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'installments_event.dart';
part 'installments_state.dart';

class InstallmentsBloc extends Bloc<InstallmentsEvent, InstallmentsState> {
  InstallmentsBloc() : super(InstallmentsInitial()) {
    on<InstallmentsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
