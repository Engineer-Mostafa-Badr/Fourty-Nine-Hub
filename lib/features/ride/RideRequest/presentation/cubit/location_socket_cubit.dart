import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/main.dart';

class LocationSocketCubit extends Cubit<RiderState> {
  SocketIoService socketIoService;
  LocationSocketCubit({required this.socketIoService}) : super(RiderInitial());

  sendSubCategoryId(String id) {
    var data = jsonEncode({
      "subcategoryId": id,
    });
    socketIoService.socket?.emit("subcategory:driver", [data]);
  }

  updateDriverLocationOn() {
    socketIoService.socket?.on(
      "driver:location",
      (data) {
        log(data.toString());
        updateDriverLocationEmit();
      },
    );
  }

  updateDriverLocationEmit() {
    if (socketIoService.socket == null) {
      log("Socket is not connected");
      return;
    }

    var data = jsonEncode({
      "location": [12, 21],
      "driverId": "string",
      "subcategoryId": "string",
    });

    socketIoService.socket!.emit("driver:location", [data]);
    socketIoService.socket!.on(
      "driver:location",
      (data) {
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
        log(data.toString(), name: "lllllllllllllllllllllll");
        log("-----------------------------------------------------",
            name: "lllllllllllllllllllllll");
      },
    );
  }
}
