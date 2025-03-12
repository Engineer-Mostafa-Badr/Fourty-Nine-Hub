import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'map_box_cubit_state.dart';

class MapBoxCubit extends Cubit<MapBoxCubitState> {
  MapBoxCubit() : super(MapBoxCubitInitial());

  List<double>? startLocation;
  // Method to call the MapBox API and handle states
  Future<void> searchLocationMapBoxStart({required String query}) async {
    try {
      emit(MapBoxCubitLoading());

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
        startLocation = [coordinates[0], coordinates[1]];
        emit(MapBoxCubitSuccess([coordinates[0], coordinates[1]]));

        break;
      } // Extract coordinates from response
      // MapBoxSearchModel searchResult = MapBoxSearchModel.fromJson(data);

      print("555555\n");
      // print(searchResult.coordinates!);
    } catch (e) {
      emit(MapBoxCubitFailure(errorMessage: e.toString()));
    }
  }
}
