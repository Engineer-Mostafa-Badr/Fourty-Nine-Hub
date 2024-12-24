import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'update_driver_location_state.dart';

class UpdateDriverLocationCubit extends Cubit<UpdateDriverLocationState> {
  final Socket _socket;

  UpdateDriverLocationCubit(this._socket)
      : super(UpdateDriverLocationInitial()) {
    _initializeSocketListeners();
  }

  void _initializeSocketListeners() {
    if (!_socket.connected) {
      _socket.connect();
      print("Socket connection initiated...");
    }

    _socket.on('.........event........', (data) {
      updateDriverLocation();
      // try {
      //   emit(GetAvailableTripsForDriversSuccess(trips: trips));
      // } catch (e) {
      //   emit(GetAvailableTripsForDriversFailure(
      //       errorMessage: 'Parsing error: ${e.toString()}'));
      // }
    });

    _socket.on('connect_error', (error) {
      print("Socket connection error: $error");
      emit(UpdateDriverLocationFailure(
          errorMessage: 'Error occurred. Please try again: $error'));
    });

    _socket.on('disconnect', (data) {
      print('Socket disconnected: $data');
    });
  }

  void updateDriverLocation() async {
    _socket.connect();
    emit(UpdateDriverLocationLoading());
    Position position = await GetCurrentLocationDriver.getCurrentPosition();

    _socket.emit('.......event.......');
  }

  @override
  Future<void> close() {
    _socket.dispose();
    return super.close();
  }
}
