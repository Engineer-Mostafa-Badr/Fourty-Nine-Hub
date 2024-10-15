import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/destination_location_carpool/cubit/map_box_dest_cubit_state.dart';

class MapBoxDestCubit extends Cubit<MapBoxDestCubitState> {
  MapBoxDestCubit() : super(MapBoxDestCubitInitial());
  List<double>? destLocation;
  Future<void> searchLocationMapBoxDest({required String query}) async {
    try {
      emit(MapBoxDestCubitLoading());

      // Make API request using Dio
      String url =
          'https://api.mapbox.com/search/geocode/v6/forward?q=$query&access_token=sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg';

      Response response = await Dio().get(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
          }));
      print(response);
      // Parse the response
      Map<String, dynamic> data = response.data;

      List<dynamic> features = data['features'];

      for (var feature in features) {
        // Accessing coordinates
        List<dynamic> coordinates = feature['geometry']['coordinates'];
        print('Longitude: ${coordinates[0]}, Latitude: ${coordinates[1]}');
        destLocation = [coordinates[0], coordinates[1]];

        emit(MapBoxDestCubitSuccess([coordinates[0], coordinates[1]]));

        break; // Extract coordinates from response
      }
      print("555555\n");
    } catch (e) {
      emit(MapBoxDestCubitFailure(errorMessage: e.toString()));
    }
  }
}
