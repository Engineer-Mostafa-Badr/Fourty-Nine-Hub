import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

part 'here_location_state.dart';

class HereLocationCubit extends Cubit<HereLocationState> {
  HereLocationCubit() : super(HereLocationInitial());
  List<double> locations = [];
  Future<void> searchLocationHere(
      {required String query, required String apiKey}) async {
    emit(HereLocationLoading());

    final String url =
        'https://geocode.search.hereapi.com/v1/geocode?q=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          // Extract latitude and longitude from the first result
          final position = data['items'][0]['position'];
          locations = [position['lat'], position['lng']];
          print("locations  $locations \n");

          emit(HereLocationSuccess(locations: locations));
        } else {
          emit(HereLocationFailure(errorMessage: 'No locations found'));
        }
      } else {
        emit(HereLocationFailure(
            errorMessage: 'Error: ${response.reasonPhrase}'));
      }
    } catch (e) {
      emit(HereLocationFailure(errorMessage: 'Failed to fetch location: $e'));
    }
  }
}
