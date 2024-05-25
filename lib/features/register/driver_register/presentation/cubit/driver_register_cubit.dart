import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'driver_register_state.dart';

class DriverRegisterCubit extends Cubit<DriverRegisterState> {
  DriverRegisterCubit() : super(DriverRegisterInitial());
}
