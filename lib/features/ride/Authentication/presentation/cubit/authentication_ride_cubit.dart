import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';

part 'authentication_ride_state.dart';

class AuthenticationRideCubit extends Cubit<AuthenticationRideState> {
  AuthenticationRideCubit() : super(AuthenticationRideInitial());

  addPart(){
    
  }
}
